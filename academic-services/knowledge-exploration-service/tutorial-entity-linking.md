---
title: Entity linking
description: Step by step tutorial to link private paper data with MAKES paper entities
ms.topic: tutorial
ms.date: 10/15/2020
---

# Link private publication records with MAKES entities

This tutorial illustrates how to link private publication records with their corresponding MAKES paper entities, enabling custom entity metadata to be generated.

## Prerequisites

- [Microsoft Academic Knowledge Service (MAKES) subscription](get-started-setup-provisioning.md)
- [Powershell 7](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7&preserve-view=true)
- [Sample private library publication records](samplePrivateLibraryData.json)
- [Sample entity linking Powershell script](linkPrivateLibraryData.ps1)

## Download samples and setup working directory

This tutorial illustrates how a fictional library would link their existing library records to the much more expansive MAKES metadata, allowing them to enhance their records and create a powerful library search website.

To get started with entity linking, create a working directory on your local filesystem and download the [sample publication records](samplePrivateLibraryData.json) and the [sample entity linking script](linkPrivateLibraryData.ps1) to it.

The sample library publication records contain the following information:

- Publication title
- URL for the publication on the library's website

Once the working directory has been setup, our next step is to determine the entity linking strategy.

## Determine entity linking strategy

In this tutorial we show how to link library records with paper entities using MAKES' [natural language processing](concepts-queries.md) capability via the [Interpret API](reference-get-interpret.md).

MAKES' default grammar supports matching natural language queries against various paper attributes (i.e. title, author names, fields of study, title/abstract terms, etc.), resulting in a query expression which can be used to retrieve corresponding paper entities. This allows us to match the publication title included in the sample library data against the MAKES paper entity's title and link them together.

To accomplish this, we call Interpret for each library record, using the publication title to generate a "scoped" query in the format of `title: <LibraryPublication Title>`. The Interpret request for linking the sample library publication against MAKES paper entity is the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

In addition to the "title" scope we also support scopes for each different type of paper attribute that can be matched:

Scope Prefix | Description | Example Query
--- | ---| ---
abstract: | Match term or quoted value from the paper abstract | abstract: heterogeneous entity graph comprised of six types of entities
affiliation: | Match affiliation (institution) name | affiliation: microsoft research
author: | Match author name | author: darrin eide
conference: | Match conference series name | conference: www
doi: | Match paper Document Object Identifier (DOI) | doi: 10.1037/0033-2909.105.1.156
journal: | Match journal name | journal: nature
title: | Match term or quoted value from the paper title | title: an overview of microsoft academic service mas and applications
fieldsofstudy: | Match paper field of study (topic) | fieldsofstudy: knowledge base
year: | Match paper publication year | year: 2015

You can experiment with these different scopes and pick the one that makes the most sense for your data/scenario using the Interpret test page. MAKES also supports custom grammars, allowing you to craft a grammar explicitly designed for the data being using to link entities. See [How to define a custom grammar](how-to-grammar.md) for more details.

## Set appropriate confidence score for linked entities

> [!Important]
> This section assumes understanding of the following MAKES concepts:
>
>- [How MAKES generates semantic interpretations of natural language queries](concepts-queries.md)
>- [Entity log probability](how-to-index-data.md#entity-log-probability)

The next step in entity linking is determining an appropriate confidence score threshold, which allows us to determine when entity linking has successfully linked a library record's title with a corresponding MAG paper. The [Interpret API](reference-get-interpret.md) returns a [log probability associated with each interpretation](reference-grammar-syntax.md#interpretation-probability), which we leverage as a "confidence score" for the given interpretation. Since the probability for an interpretation can range from 0 to 1, the interpretation log probability can be anywhere from zero to negative infinity.

The interpretation log probability value actually represents the sum of two *different* log probabilities which we need to disentangle. The first log probability, grammar path log probability, is associated with the different attributes matched in the natural language grammar that the Interpret API uses, and is used to represent how likely an interpretation is to be correct based on rules defined in the grammar. The second log probability, [entity log probability](how-to-index-data.md#entity-log-probability), is associated with the top matching entity for the interpretation.

> [!Note]
> The default MAKES grammar assigns *log probability penalties* for different types of attribute matches to either encourage or discourage their use. For example, the grammar *favors* complete publication title matching by not assigning a penalty when it is fully matched. However, when only *part of a title* is matched, i.e. individual words, each word is assigned a log probability penalty of -1. Similarly, when individual words from a papers abstract are matched, a heavier penalty of -3 is applied. The heaviest penalty, -25, is applied when a query term cannot be matched against any known paper attributes.
>
> See the entity linking example at the bottom of the page for a clearer illustration of this

For entity linking, we want to isolate the grammar path log probability from the interpretation log probability (represented by `interpretations[0].logprob`), as it best reflects the *quality* of the match. Because the interpretation log probability is the sum of the two different log probabilities, we calculate the grammar path log probability by simply subtracting the top matching entity's log probability (represented by `interpretations[0].rules[0].output.entities[0].logprob`) from the interpretation log probability. 

Using one of the sample library publication titles as an example:

```json
{
    "query": "title: cultural intelligence trait competitiveness and multicultural team experiences",
    "interpretations": [
        {
            "logprob": -94.454,
            "parse": "<rule name=\"#GetPapers\">title: <attr name=\"academic#W\">cultural</attr> <attr name=\"academic#W\">intelligence</attr> trait <attr name=\"academic#AW\">competitiveness</attr> and <attr name=\"academic#AW\">multicultural</attr> team <attr name=\"academic#AW\">experiences</attr><end/></rule>",
            "rules": [
                {
                    "name": "#GetPapers",
                    "output": {
                        "type": "query",
                        "value": "And(And(And(And(W='cultural',W='intelligence'),AW='competitiveness'),AW='multicultural'),AW='experiences')",
                        "entities": [
                            {
                                "logprob": -22.454,
                                "prob": 1.771543E-10,
                                "kesEntityId": 20110523,
                                "Id": 96291970,
                                "Ti": "cultural intelligence antecedents and propensity to accept a foreign based job assignment"
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

The grammar path log probability for the sample response above would be `-94.454 - (-22.454) = -72`, which given the default grammar likely does not reflect an accurate match (note that the exact title is not matched, words from both the title and abstract are used to match, and some words are not matched at all).

The sample entity linking script uses `-50` as the confidence score threshold for linking data. This allows for some penalization in the title match (e.g. up to two query terms being dropped), but generally reflects a reasonably confident match.

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_log_probability_as_confidence_score":::

Depending on your linking strategy, you may want to set a different confidence cut off score. For example, you can set a lower confidence cut off score if having false positives (incorrect linked entities) doesn't impact your use case. You may also want to design a custom grammar to create a better scoring system for your scenario. For example, if your private data is a list of MLA formatted references, you may want to create a grammar that parses out author, title, and venue and have lower penalties for unmatched terms.

## Choose MAKES entity attributes to include

Next we determine which MAKES entity attributes we want to include with our library records that can help enrich our private data. See the [MAKES Entity Schema](reference-makes-api-entity-schema.md) to explore the different types and entities and attributes available in the MAKES' default index.

In this tutorial, the sample library publication records only contain a paper title and a fake library URL. The goal of the tutorial is to augment the minimal information with additional metadata from MAKES, enabling a robust semantic/keyword search experience.

In the sample entity linking Powershell script, we leverage paper entity's DOI, citation count, abstract, fields of study, authors, affiliations, journal, and conference information to enrich our data and support semantic/keyword search.

We retrieve this information using the "attributes" parameter in our Interpret request as the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

If we're able to find an interpretation that meets our confidence cut off score, we will then merge the entities together using the following helper function:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_merge_entities":::

## Run sample solution to see entity linking in action

- Deploy a MAKES instance by following the [Create API Instance](get-started-create-api-instances.md) guide
- [Download Sample Library Data](samplePrivateLibraryData.json) to your working directory
- Copy the below script and paste it into your favorite editor
:::code language="powershell" source="linkPrivateLibraryData.ps1":::
- Modify the script and set the **makesEndpoint** variable to your deployed MAKES instance url
- Save the script as "linkPrivateLibraryData.ps1" to your working directory
- Open up a powershell console and run the sample entity linking script. Make sure the sample library data and linking script are under the same directory.

The sample entity linking script output should look like the following:

```
Linked | Confidence Score | Original Title | MAG Title
---- | ---- |---- |----
True | 0 | Microsoft Academic Graph: When experts are not enough | Microsoft Academic Graph: When experts are not enough
True | 0 | An Overview of Microsoft Academic Service (MAS) and Applications | An Overview of Microsoft Academic Service (MAS) and Applications
False | -143 | The impact of support system of enterprise organization on Taiwanese expatriates’ work-family conflict | What happens after ERP implementation: understanding the impact of interdependence and differentiation on plant-level outcomes
True | 0 | Organisational justice and customer citizenship behaviour of retail industries | Organisational justice and customer citizenship behaviour of retail industries
True | 0 | A Scalable Hybrid Research Paper Recommender System for Microsoft Academic | A Scalable Hybrid Research Paper Recommender System for Microsoft Academic
True | 0 | Network Embedding as Matrix Factorization: Unifying DeepWalk, LINE, PTE, and node2vec | Network Embedding as Matrix Factorization: Unifying DeepWalk, LINE, PTE, and node2vec
True | 0 | Autonomous Thermalling as a Partially Observable Markov Decision Process (Extended Version) | Autonomous Thermalling as a Partially Observable Markov Decision Process (Extended Version).
True | 0 | CORD-19: The Covid-19 Open Research Dataset | CORD-19: The Covid-19 Open Research Dataset.
False | -72 | Cultural Intelligence, Trait Competitiveness and Multicultural Team Experiences | Cultural Intelligence: Antecedents and Propensity to Accept a Foreign-Based Job Assignment
True | 0 | ERD'14: entity recognition and disambiguation challenge | ERD'14: entity recognition and disambiguation challenge
True | 0 | Clickage: towards bridging semantic and intent gaps via mining click logs of search engines | Clickage: towards bridging semantic and intent gaps via mining click logs of search engines
True | 0 | An Overview of Microsoft Web N-gram Corpus and Applications | An Overview of Microsoft Web N-gram Corpus and Applications
True | 0 | Interactive semantic query suggestion for content search | Interactive semantic query suggestion for content search
True | 0 | Exploring and exploiting user search behavior on mobile and tablet devices to improve search relevance | Exploring and exploiting user search behavior on mobile and tablet devices to improve search relevance
True | 0 | Exploring web scale language models for search query processing | Exploring web scale language models for search query processing
True | 0 | TaxoExpan: Self-supervised Taxonomy Expansion with Position-Enhanced Graph Neural Network | TaxoExpan: Self-supervised Taxonomy Expansion with Position-Enhanced Graph Neural Network
True | 0 | Heterogeneous Graph Transformer | Heterogeneous Graph Transformer
True | 0 | Web scale NLP: a case study on url word breaking | Web scale NLP: a case study on url word breaking
True | 0 | GPT-GNN: Generative Pre-Training of Graph Neural Networks | GPT-GNN: Generative Pre-Training of Graph Neural Networks
True | 0 | MIPAD: A NEXT GENERATION PDA PROTOTYPE | MIPAD: A NEXT GENERATION PDA PROTOTYPE
True | 0 | A Century of Science: Globalization of Scientific Collaborations, Citations, and Innovations | A Century of Science: Globalization of Scientific Collaborations, Citations, and Innovations
True | 0 | PSkip: estimating relevance ranking quality from web search clickthrough data | PSkip: estimating relevance ranking quality from web search clickthrough data
True | 0 | Distributed speech processing in miPad's multimodal user interface | Distributed speech processing in miPad's multimodal user interface
True | 0 | Establishing Organizational Ethical Climates: How Do Managerial Practices Work? | Establishing Organizational Ethical Climates: How Do Managerial Practices Work?
True | 0 | Case studies in contact burns caused by exhaust pipes of motorcycles | Case studies in contact burns caused by exhaust pipes of motorcycles
True | 0 | Is Playfulness a Benefit to Work? Empirical Evidence of Professionals in Taiwan | Is playfulness a benefit to work? Empirical evidence of professionals in Taiwan
True | 0 | Charismatic Leadership and Follower Traits of Self-Consciousness | Charismatic Leadership and Follower Traits of Self-Consciousness
True | 0 | Sense of calling in the workplace: The moderating effect of supportive organizational climate in Taiwanese organizations | Sense of calling in the workplace: The moderating effect of supportive organizational climate in Taiwanese organizations
True | 0 | Charismatic leadership and self‐leadership: A relationship of substitution or supplementation in the contexts of internalization and identification? | Charismatic leadership and self‐leadership: A relationship of substitution or supplementation in the contexts of internalization and identification?
True | 0 | The effects of physicians’ personal characteristics on innovation readiness in Taiwan’s hospitals | The effects of physicians' personal characteristics on innovation readiness in Taiwan's hospitals
True | 0 | Cultural influences in acquiescent response: A study of trainer evaluation biases | Cultural Influences in Acquiescent Response: A Study of Trainer Evaluation Biases
True | 0 | Self-managers: Social contexts, personal traits, and organizational commitment | Self-managers: Social contexts, personal traits, and organizational commitment
True | 0 | The meaningfulness of managerial work: case of Taiwanese employees | The meaningfulness of managerial work: case of Taiwanese employees
True | 0 | When perceived welfare practices leads to organizational citizenship behavior | When perceived welfare practices leads to organizational citizenship behavior
True | 0 | Negative Effects of Abusive Supervision: The Path Through Emotional Labor | Negative Effects of Abusive Supervision: The Path Through Emotional Labor
True | -47 | The Mediating Mechanisms between Prosocial Motivation and Job Performance in Mission-driven Organizations | The mediating effect of calling and job involvement on prosocial motivation and performance
False | -90 | Age and Gender Differences in Playfulness and Innovation Behavior among Professional Workers | THE INFLUENCE OF GENDER, AGE AND PROFESSION- RELATED DIFFERENCES ON THE VERBAL BEHAVIOR OF THE SUBJECTS OF ASSOCIATION
True | -4 | Factors affecting training transfer | Factors Affecting Motivation to Transfer Training.
True | 0 | A Review of Microsoft Academic Services for Science of Science Studies | A Review of Microsoft Academic Services for Science of Science Studies
False | -64 | Survey on corporate motivations for culture and arts sponsorship | The Art of Co-Creative Media: An Australian Survey
False | -287 | The Relationship among Transformational Leadership, Public Administrative Ethic and Organizational Citizenship Behavior: An empirical sturdy for tax bureau district office of Kaohsiung | Master's Thesis: An empirical research to the relationship between Ethical Leadership and followers' Organizational Citizenship Behavior
False | -83 | The relationship between Advisors’ Leadership Behaviors and Graduate Students’ Achievement Motives | The Relationship between Transformational Leadership Behaviors of Faculty Supervisors and Self-Efficacies of Graduate Assistants.
False | -145 | The Effects of Budgetary Goal Difficulty, Task Uncertainty and Budgetary Emphasis on Performance: Moderated Regression Analysis | THE JOINT EFFECTS OF BUDGETARY SLACK AND TASK UNCERTAINTY ON SUBUNIT PERFORMANCE
False | -102 | Promoting Participation in Performing Arts Activities through Internet Technology: A Case Study in Taiwan. | Enhancing students' learning experience and promoting inclusive practice via social media
```

You can use the parsed grammar path see how the grammar path log probability/confidence score is derived. For example, submit the following request using the Interpret test page to see how the -72 confidence score is derived for "Cultural Intelligence, Trait Competitiveness and Multicultural Team Experiences":

```json
{
  "query": "title: Cultural Intelligence, Trait Competitiveness and Multicultural Team Experiences",
  "complete": 0,
  "normalize": 1,
  "attributes": "Id,Ti",
  "offset": 0,
  "timeout": 2000,
  "count": 1,
  "entityCount": 1
}
```

The response should look like the following:

```json
{
    "query": "title: cultural intelligence trait competitiveness and multicultural team experiences",
    "interpretations": [
        {
            "logprob": -94.454,
            "parse": "<rule name=\"#GetPapers\">title: <attr name=\"academic#W\">cultural</attr> <attr name=\"academic#W\">intelligence</attr> trait <attr name=\"academic#AW\">competitiveness</attr> and <attr name=\"academic#AW\">multicultural</attr> team <attr name=\"academic#AW\">experiences</attr><end/></rule>",
            "rules": [
                {
                    "name": "#GetPapers",
                    "output": {
                        "type": "query",
                        "value": "And(And(And(And(W='cultural',W='intelligence'),AW='competitiveness'),AW='multicultural'),AW='experiences')",
                        "entities": [
                            {
                                "logprob": -22.454,
                                "prob": 1.771543E-10,
                                "kesEntityId": 20110523,
                                "Id": 96291970,
                                "Ti": "cultural intelligence antecedents and propensity to accept a foreign based job assignment"
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

The formatted grammar path parse is:

```xml
<rule name="#GetPapers">
    title:  
    <attr name="academic#W">cultural</attr>
    <attr name="academic#W">intelligence</attr>  
    trait  
    <attr name="academic#AW">competitiveness</attr>  
    and  
    <attr name="academic#AW">multicultural</attr>  
    team  
    <attr name="academic#AW">experiences</attr>
    <end/>
</rule>
```

Using the parse above and the default MAKES grammar rules definition, the accumulative penalties can be broken down by :

1. Scoped title words search (":title"), receiving penalty of -1
1. Match 2 title words consecutively ("cultural", "intelligence"), receiving penalty of -2 (-1 * 2)
1. Main loop repeat, receiving penalty of -1
1. Unable to match "trait", receiving penalty of -25
1. Main loop repeat, receiving penalty of -1
1. Match 2 abstract words consecutively ("competitiveness", "multicultural") receiving penalty of -9 (-3 + -3 * 2)
1. Main loop repeat, receiving penalty of -1
1. Unable to match "team", receiving penalty of -25
1. Main loop repeat, receiving penalty of -1
1. Match abstract word "competitiveness" receiving penalty of -6 (-3 + -3)

## Next steps

Advance to the next section to learn how to build a library application to filter the publications.

> [!div class="nextstepaction"]
> [Build a library application with smart filters](tutorial-schema-design.md)