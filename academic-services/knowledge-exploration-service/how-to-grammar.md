---
title: Grammar format
description: Defines the file format and structure for MAKES grammars
ms.topic: tutorial
ms.date: 9/1/2020
---

# How to define a custom grammar

This document details the composition of a MAKES grammar and the role of a grammar in allowing natural language processing in MAKES via Interpret API.

## Natural language processing with grammars

MAKES supports natural language query interpretation through the [Interpret API](reference-get-interpret.md), which requires a [Context Free Grammar (CFG)](https://academic.microsoft.com/topic/97212296) adhering to the [Speech Recognition Grammar Specification (SRGS)](https://www.w3.org/TR/speech-grammar/) format, a W3C standard for speech recognition grammars with support for generating semantic interpretations.

In the context of the SRGS, MAKES Interpret API act as a *speech recognizer* specified by a MAKES grammar. MAKES Interpret API takes an input stream (natural language query) and tries to match it to a series of *rules* defined in the grammar, which in turn generate [structured query expressions](concepts-query-expressions.md) as their output. Structured query expressions are what MAKES uses to retrieve entities matching a specific set of constraints.

A *rule* is defined as one or more of the following:

* [Text nodes](https://www.w3.org/TR/REC-DOM-Level-1/level-one-core.html#ID-1312295772) (the text inside of an element), or "tokens" are text that must be exactly matched in the natural language query for further expansion
* [Indexed attribute references](reference-grammar-syntax.md#attrref-element) (```<attrref>```) allow natural language query terms to be matched with [indexed data](how-to-index-schema.md)
* [Rule references](reference-grammar-syntax.md#ruleref-element) (```<ruleref>```) expand rules defined using the [```rule```](reference-grammar-syntax.md#rule-element) element
* [Tags](reference-grammar-syntax.md#tag-element) (```<tag>```) modifies the context/interpretation of a grammar path using [semantic functions](reference-semantic-functions.md)
* [Sequence enclosures](reference-grammar-syntax.md#item-element) (```<item>```) expand rules defined inside the enclosing element
* [Alternative enclosures](reference-grammar-syntax.md#one-of-element) (```<one-of>```) allow for different interpretations to be generated based on "alternate" matching criteria

The act of *rule expansion* is the progressive matching of the natural language query with different sequences of rules. These expansions generate a parse tree, with indexed attribute references and alternative expansions creating branches in the tree. Rule expansion starts with the [root grammar rule](reference-grammar-syntax.md#grammar-element) and for each branch ends once there are either no more rules to be matched (end of grammar) *or* no more rules can be matched (end of query).

Each leaf node in the parse tree that matches *both* criteria (end of grammar *and* end of query) will result in a valid interpretation of the natural language query.

## Example grammar

See below for an example grammar that defines rules for matching a small subset of attributes from the [example academic paper entity schema](how-to-index-schema.md#academic-paper-entity-schema) against a natural language query:

```xml
<grammar root="paperQuery">
  <import schema="schema.json" name="paperEntity" />

  <rule id="paperQuery">

    <!-- Variable containing final structured query expression -->
    <tag>outputQueryExpression = All();</tag>

    <!-- The following enclosure is repeated indefinitely (one to infinity), 
       with each repeat incurring a weight penalty of -1 -->
    <item repeat="1-INF" repeat-logprob="-1">

      <one-of>

        <!-- Match paper conference series attribute -->
        <item>
          <attrref uri="paperEntity#C.CN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper conference instance attribute -->
        <item>
          <attrref uri="paperEntity#CI.CIN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper field of study attribute -->
        <item>
          <attrref uri="paperEntity#F.FN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper title word attribute -->
        <item>
          <attrref uri="paperEntity#W" name="matchedAttribute" />
        </item>

        <!-- Match paper publication year attribute -->
        <item>
          <ruleref uri="#paperYear" name="matchedAttribute" />
        </item>

      </one-of>

      <!-- Add matched attribute to existing query expression as a new constraint -->
      <tag>outputQueryExpression = And(outputQueryExpression, matchedAttribute);</tag>
    </item>

    <!-- Set output of rule to the query expression we constructed above -->
    <tag>out = Resolve(outputQueryExpression);</tag>

  </rule>

  <rule id="paperYear">

    <one-of>

      <!-- Match paper publication year attribute -->
      <item>
        <attrref uri="paperEntity#Y" name="out" />
      </item>

      <!-- Match paper publication year attribute before a specific year -->
      <item>
        <one-of>
            <item>before</item>
            <item logprob="-1">written before</item>
        </one-of>
        <attrref uri="paperEntity#Y" name="out" op="lt" />
      </item>

      <!-- Match paper publication year attribute after a specific year -->
      <item>
        <one-of>
            <item>after</item>
            <item logprob="-1">written after</item>
        </one-of>
        <attrref uri="paperEntity#Y" name="out" op="gt" />
      </item>

    </one-of>

  </rule>

</grammar>
```

## Example rule expansion

We can illustrate how rule expansion happens through the above grammar using the sample query "knowledge discovery and data mining 2019 deep learning" and the example index created in the ["create custom MAKES index" how-to guide](how-to-index-build.md). This illustration attempts to model what the parse tree generated from each subsequent rule expansion might look like, and **only includes branches resulting in valid interpretations**:

1. "knowledge discovery and data mining" => synonym of conference series named "kdd"
    1. "2019" => publication year "2019", weight -1, accumulated weight -1
        1. "deep learning" => field of study "deep learning", weight -1, accumulated weight -2
            1. END OF QUERY, top matching paper "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks", weight -18.942, accumulated weight -20.942
        1. "deep" => title word "deep", weight -1, accumulated weight -2
            1. "learning" => title word "learning", weight -1, accumulated weight -3
                1. END OF QUERY, top matching paper "Sherlock: A Deep Learning Approach to Semantic Data Type Detection", weight -19.03, accumulated weight -22.03
1. "knowledge discovery and data mining 2019" => synonym of conference instance named "kdd 2019"
    1. "deep learning" => field of study "deep learning", weight -1, accumulated weight -1
        1. END OF QUERY, top matching paper "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks", weight -18.942, accumulated weight -19.942
    1. "deep" => title word "deep", weight -1, accumulated weight -1
        1. "learning" => title word "learning", weight -1, accumulated weight -2
            1. END OF QUERY, top matching paper "Sherlock: A Deep Learning Approach to Semantic Data Type Detection", weight -19.03, accumulated weight -21.03

The full parse tree including invalid interpretations would be significantly larger, as each possible alternative enclosure and indexed attribute reference are expanded and tested. For example, using the query term "2019" at node 1.a. in the above illustration:

1. "knowledge discovery and data mining" => synonym of conference series named "kdd"
    1. "2019" => publication year "2019"
        1. Positive match, continue rule expansion with next query term(s) "deep..."
    1. "2019" => conference series named "2019"
        1. Negative match, end expansion as no more rules can be matched
    1. "2019" => conference instance named "2019"
        1. Negative match, end expansion as no more rules can be matched
    1. "2019" => field of study named "2019"
        1. Negative match, end expansion as no more rules can be matched
    1. "2019" => title word matching "2019"
        1. Negative match, end expansion as no more rules can be matched

Another important item illustrated above are the weights associated with each rule expansion. Once all interpretations have been generated, the interpretations are ranked based on the *cumulative weight (log probability)* of each interpretations associated parse tree path, which includes weights associated with grammar rule expansions (i.e. `<item>`) and the weight of any indexed entity whose attributes were matched. See [interpretation probability](reference-grammar-syntax.md#interpretation-probability) for more details.

## Example Interpret API response

The MAKES Interpret API would generate the following response for the same query:

```json
{
  "query": "knowledge discovery and data mining 2019 deep learning",
  "interpretations": [
    {
      "logprob": -19.942,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#CI.CIN\" canonical=\"kdd 2019\">knowledge discovery and data mining 2019</attr> <attr name=\"paperEntity#F.FN\">deep learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(Composite(CI.CIN=='kdd 2019'),Composite(F.FN='deep learning'))",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -20.942,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#C.CN\" canonical=\"kdd\">knowledge discovery and data mining</attr><rule name=\"#paperYear\"> <attr name=\"paperEntity#Y\">2019</attr></rule> <attr name=\"paperEntity#F.FN\">deep learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(Composite(C.CN=='kdd'),Y=2019),Composite(F.FN='deep learning'))",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        },
        {
          "name": "#paperYear",
          "output": {
            "type": "query",
            "value": "Y=2019",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -21.03,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#CI.CIN\" canonical=\"kdd 2019\">knowledge discovery and data mining 2019</attr> <attr name=\"paperEntity#W\">deep</attr> <attr name=\"paperEntity#W\">learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(Composite(CI.CIN=='kdd 2019'),W='deep'),W='learning')",
            "entities": [
              {
                "logprob": -19.03,
                "prob": 5.4372088E-09,
                "DN": "Sherlock: A Deep Learning Approach to Semantic Data Type Detection"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -22.03,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#C.CN\" canonical=\"kdd\">knowledge discovery and data mining</attr><rule name=\"#paperYear\"> <attr name=\"paperEntity#Y\">2019</attr></rule> <attr name=\"paperEntity#W\">deep</attr> <attr name=\"paperEntity#W\">learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(And(Composite(C.CN=='kdd'),Y=2019),W='deep'),W='learning')",
            "entities": [
              {
                "logprob": -19.03,
                "prob": 5.4372088E-09,
                "DN": "Sherlock: A Deep Learning Approach to Semantic Data Type Detection"
              }
            ]
          }
        },
        {
          "name": "#paperYear",
          "output": {
            "type": "query",
            "value": "Y=2019",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
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

We can map the example rule expansion in the previous section to this response in the following ways:

* "cumulative weight (log probability)" => "logprob"
* "parse tree path" => "parse"
* "top matching paper" => "rules"."output"."entities"[0]

This response also highlights an important concept mentioned in the first part of this section, the generation of [structured query expressions](concepts-query-expressions.md) as the output of each interpretation. These are shown in "rules"."output"."value".

## Next steps

Advance to the next section to learn how to build and test a custom MAKES grammar using the example data presented in the previous sections.

> [!div class="nextstepaction"]
>[Build and test grammar](how-to-grammar-build.md)