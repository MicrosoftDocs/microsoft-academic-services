---
title: Entity linking
description: Step by step tutorial to link private paper data with MAKES paper entities
ms.topic: tutorial
ms.date: 10/15/2020
---

# Entity Linking

This tutorial illustrates how to link private publication records with their corresponding MAKES paper entities, enabling custom entity metadata to be generated.

## Prerequisites

- [Microsoft Academic Knowledge Service (MAKES) subscription](get-started-setup-provisioning.md)
- [Powershell 7](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7&preserve-view=true)
- [Sample private library publication records](samplePrivateLibraryData.json)
- [Sample entity linking Powershell script](linkPrivateLibraryData.ps1)

## Download samples and setup working directory

This tutorial illustrates how a fictional library could go about linking their existing, minimal library records to the much more expansive MAG/MAKES metadata, allowing them to enhance their records and create a powerful library search website.

To get started with entity linking, create a working directory on you local filesystem and download the [sample publication records](samplePrivateLibraryData.json) and the [sample entity linking script](linkPrivateLibraryData.ps1) to it.

As mentioned, the sample library publication records contain minimal information:

- Publication title
- URL for the publication on the library's website

Once the working directory has been setup, our next step is to determine the entity linking strategy.

## Determine entity linking strategy

Once we know what entity we want to link our data against, we can determine the appropriate linking strategy. In abstract, we'll leverage MAKES' [natural language processing](concepts-queries.md) capability via Interpret API to link entities.

MAKES' default grammar supports matching natural language queries against various paper attributes (i.e. title, author names, fields of study, title/abstract terms, etc.), resulting in a query expression which can be used to retrieve corresponding paper entities.

Our sample library data includes a title. We can leverage MAKES' paper title search capability to link our data. We achieve this by sending Interpret requests to a MAKES instance with the query attribute being `title: [library paper title]` as the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

You can leverage the Interpret test page to explore different scope search requests and pick the one that makes the most sense for your scenario. Below is a table of different scope search that the default MAKES grammar supports:

Scope Prefix | Description | Example Query
--- | ---| ---
abstract: | Match term or quoted value from the paper abstract | abstract: “heterogeneous entity graph comprised of six types of entities”
affiliation: | Match affiliation (institution) name | affiliation: “microsoft research”
author: | Match author name | author: “darrin eide”
conference: | Match conference series name | conference: www
doi: | Match paper Document Object Identifier (DOI) | doi: 10.1037/0033-2909.105.1.156
journal: | Match journal name | journal: nature
title: | Match term or quoted value from the paper title | title: “an overview of microsoft academic service mas and applications”
fieldsofstudy: | Match paper field of study (topic) | fieldsofstudy: “knowledge base”
year: | Match paper publication year | year: 2015

You can also build a custom grammar to better fit your linking scenario. See [How to define a custom grammar](how-to-grammar.md) for more detail.

## Set appropriate confidence score for linked entities

>
> [!Important]
> This section heavily depends on the understanding of the following MAKES concepts:
>
>- [How MAKES generates semantic interpretations of natural language queries](concepts-queries.md)
>- [Entity log probability](how-to-index-data.md#entity-log-probability)

Next we need to set an appropriate confidence score threshold to help us determine when entity linking has successfully linked a library record's title with a corresponding MAG paper. The [Interpret API](reference-get-interpret.md) returns a [log probability associated with each interpretation](reference-grammar-syntax.md#interpretation-probability), which can be used as a "confidence score" for the given interpretation. Since the probability for an interpretation can range from 0 to 1, the log probability for an interpretation can be anywhere from zero to negative infinity.

This interpretation log probability value represents the sum of two different log probabilities. The first is the log probability assigned by the natural language grammar that the Interpret API uses, and represents the log probability that an interpretation is correct based on rules defined in the grammar. The second is the log probability associated with the top entity matching the interpretation.

For entity linking, we want to isolate the grammar log probability as it reflects the quality of the match. To isolate the grammar log probability we subtract the top matching entity's log probability.

The default MAKES grammar has various penalties associated with the different types of matching. For example, the grammar favors a complete title match by having a penalty of -1. A word matching a paper's abstract word instead of a title word will result a penalty of -3. The steepest penalty, -25 is when a word cannot be matched against any paper attributes. *BLEBH* for more detailed walkthrough of the default grammar, see the entity linking example score walk through bellow *BLEBH*

The sample entity linking script uses **-50** as the cut off confidence score for linking data. This allows for some penalization for entity linking, such as two title word mismatch.

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_log_probability_as_confidence_score":::

Depending on your linking strategy, you may want to set a different confidence cut off score. For example, you can set a lower confidence cut off score if having false positives (incorrect linked entities) doesn't impact your use case. You may also want to design a custom grammar to create a better scoring system for your scenario. For example, if your private data is a list of MLA formatted references, you may want to create a grammar that parses out author, title, and venue and have lower penalties for unmatched terms.

## Choose MAKES entity attributes to include

Next we determine which MAKES entity attributes we want to include with our library records that can help enrich our private data. See the [MAKES Entity Schema](reference-makes-api-entity-schema.md) to explore the different types and entities and attributes available in the MAKES' default index.

In this tutorial, the sample private library publication records only contains a paper title and fake library URL. The goal of the tutorial is to augment the minimal information with additional metadata from MAKES, enabling a robust semantic/keyword search experience.

In the sample entity linking Powershell script, we will leverage paper entity's DOI, citation count, abstract, fields of study, authors, affiliations, journal, and conference information to enrich our data and support semantic/keyword search.

We retrieve this information using the "attributes" parameter in our Interpret request as the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

If we're able to find an interpretation that meets our confidence cut off score, we will then merge the entities together using the following helper function:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_merge_entities":::

## Run sample solution to see entity linking in action

1. Deploy a MAKES instance by following the [Create API Instance](get-started-create-api-instances.md) guide
1. Download [Sample Library Data](samplePrivateLibraryData.json)
1. Download [Sample Entity Linking Script](linkPrivateLibraryData.ps1)
1. Modify the entity linking script and set the **makesEndpoint** variable to your deployed MAKES instance url
1. Open up a powershell console and run the sample entity linking script. Make sure the sample library data and linking script are under the same directory.

The sample entity linking script output should look like the following:

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

You can use the parsed grammar path see how the grammar score/confidence score is derived. For example, submit the following request using the Interpret test page to see how the -72 confidence score is derived for "Cultural Intelligence, Trait Competitiveness and Multicultural Team Experiences":

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
1. Match 2 title words ("cultural", "intelligence"), receiving penalty of -2 (-1 * 2)
1. Main loop repeat, receiving penalty of -1
1. Unable to match "trait", receiving penalty of -25
1. Main loop repeat, receiving penalty of -1
1. Match 2 abstract words ("competitiveness", "multicultural") receiving penalty of -9 (-3 + -3 * 2)
1. Main loop repeat, receiving penalty of -1
1. Unable to match "team", receiving penalty of -25
1. Main loop repeat, receiving penalty of -1
1. Match abstract word "competitiveness" receiving penalty of -6 (-3 + -3)

## Next steps

Advance to the next section to learn how to design a MAKES schema to enable filter and search for the library data.
