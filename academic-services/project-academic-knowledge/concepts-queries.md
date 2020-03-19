---
title: Natural Language Queries
description: Describes how the Interpret method generates semantic interpretations of a natural language query
ms.topic: reference
ms.date: 2020-03-19
---

# How Interpret generates semantic interpretations of natural language queries

This article describes how the [Interpret method](reference-interpret-method.md) generates semantic interpretations of a natural language query that enable entities to be retrieved. It is intended for developers who require a deeper understanding of the architecture and techniques used.

## Architecture overview and diagram

Processing a natural language query is a multi-stage process that starts with lexical analysis of the query, allowing the query to be rewritten for optimal search performance. The rewritten query is then parsed and interpretations hypothesized using a [Context Sensitive Grammar (CSG)](https://en.wikipedia.org/wiki/Context-sensitive_grammar). Valid hypotheses are resolved into full semantic query expressions which are in turn used to generate the complete interpretation response.

:::image type="content" source="media/concept-semantic-interpretation-flow.png" alt-text="Semantic Interpretation Generation Architecture":::

## Stage 1: Lexical analysis

:::image type="content" source="media/concept-semantic-interpretation-lexical.png" alt-text="Semantic Interpretation Generation Architecture - Lexical Analysis":::

Lexical analysis of the user query is done to help ensure that valid interpretation hypotheses can be generated.

Currently this is composed of normalization and query operator extraction.

### Normalization

Normalization transforms the query based on specific rules:

* Removing non-essential words (stopwords, such as "the", "and", etc.)
* Lower casing word letters to ensure uniformity with indexed data
* Encoding specific types of academic concepts (i.e. equations, formulas, chemical compounds, etc.) to ensure they match the indexed data

### Query operators

Interpret supports a small handful of query operators that tell the grammar parser to perform a specific way when generating hypotheses:

* '+' before a term indicates the term is required in any valid hypothesis
* 'attributeName:' before a term indicates the term can only be interpreted using values of that type, for example 'author:john platt' indicates that the terms 'john' and 'platt' can only be hypothesized as an author name(s).

The supported attributes include:

* **abstract**: Unique words from abstract (AW)
* **affiliation**: Affiliation name (AA.AfN)
* **author**: Author name (AA.AuN)
* **conference**: Conference series name (C.CN)
* **conferenceinstance**: Conference instance name (CI.CIN)
* **doi**: Digital Object Identifier (DOI)
* **fieldofstudy**: Field of study name (F.FN)
* **journal**: Journal name (J.JN)
* **title**: Full title (Ti) or unique words from title (W)
* **year**: Publication year (Y)

## Stage 2: Generate valid interpretation hypotheses

:::image type="content" source="media/concept-semantic-interpretation-hypothesis.png" alt-text="Semantic Interpretation Generation Architecture - Generate interpretation hypotheses":::

Semantic interpretation generation is broken into two important steps. The first of these is generating interpretation hypotheses using a [Context Sensitive Grammar (CSG)](https://en.wikipedia.org/wiki/Context-sensitive_grammar) conforming to the [Speech Recognition Grammar Specification (SRGS)](https://www.w3.org/TR/speech-grammar/).

Generally SRGS grammars are context-free, meaning grammar rules can be matched lacking any additional context of previously matched rules. The Interpret method changes this behavior by including a *grammar context* that enables rules to reference metadata from previously matched rules.

The default SRGS grammar is very simple, with a single top-level rule which is allowed to repeat until all query terms have been processed:

* GetPapers
  * For current term(s) do *one* of the following:
    * Match term to paper title words available in the current grammar context
    * Match term to paper abstract words available in the current grammar context
    * Match terms to paper authors available in the current grammar context
    * Match terms to paper affiliations available in the current grammar context
    * Match terms to paper fields of study available in the current grammar context
    * Match terms to paper conferences available in the current grammar context
    * Match terms to paper journals available in the current grammar context
    * Match term to paper publication years available in the current grammar context
    * Match term to paper DOI available in the current grammar context
    * Match term to special "garbage" attribute which matches *any value* (this allows grammar to ignore query terms that might be misspelled/malformed/filler)
    * If no more terms are present, generate interpretation hypothesis

It's important to understand that each hypothesis generates *sub-hypotheses* in the form of an expansion-tree, and each tree branch *gets its own unique copy of the grammar context*. This allows us to generate many potential hypothesis that fully explore the search space for a given query.

## Stage 3: Resolve valid interpretation hypotheses

:::image type="content" source="media/concept-semantic-interpretation-resolve.png" alt-text="Semantic Interpretation Generation Architecture - Resolve valid hypothesis":::

Once a valid hypothesis has been found, the Interpret method *resolves* the hypothesis into an interpretation by generating and storing the following:

* A probability score for the hypothesis. This is the static rank of the top-most entity returned by the hypothesis plus any alternative [weight penalties imposed by the SRGS grammar](https://www.w3.org/TR/speech-grammar/#S2.4)
* XML containing the grammar rules and attributes matched to generate the hypothesis
* A [structured query expression](concepts-query-expressions.md) that can be used to find all entity results matching the hypothesis
* Optionally the top matching entities themselves can be also be returned

## Stage 4: Generate interpretation response

The final stage of semantic interpretation generation aggregates all the hypotheses that were found and generates a JSON response.

An example response for the example query "john platt nature 2019" would look like the following:

```JSON
{
    "query": "john platt nature 2019",
    "interpretations": [
        {
            "logprob": -17.722,
            "parse": "<rule name=\"#GetPapers\"><attr name=\"academic#AA.AuN\">john platt</attr> <attr name=\"academic#J.JN\">nature</attr> <attr name=\"academic#Y\">2019</attr><end/></rule>",
            "rules": [
                {
                    "name": "#GetPapers",
                    "output": {
                        "type": "query",
                        "value": "And(And(Composite(AA.AuN=='john platt'),Composite(J.JN=='nature')),Y=2019)",
                        "entities": [
                            {
                                "logprob": -17.722,
                                "Ti": "quantum supremacy using a programmable superconducting processor"
                            }
                        ]
                    }
                }
            ]
        }
    ],
    "timed_out_count": 0,
    "timed_out": false
}
```

What is included (i.e. how many results, starting offset, etc.) is controlled by the request parameters. For information about the format of the response, see the [Interpret method](reference-interpret-method.md).

## See also

[Interpret API method documentation](reference-interpret-method.md)

[Query expression syntax](reference-query-expression-syntax.md)