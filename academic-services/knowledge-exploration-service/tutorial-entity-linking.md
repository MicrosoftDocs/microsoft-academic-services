---
title: Entity linking
description: Step by step tutorial to link private paper data with MAKES paper entities
ms.topic: tutorial
ms.date: 10/15/2020
---

# Entity Linking

his tutorial illustrates how to link private publication records with their corresponding MAKES paper entities, enabling custom entity metadata to be generated.

## Prerequisites

- [Microsoft Academic Knowledge Service (MAKES) subscription](get-started-setup-provisioning.md)
- [Powershell 7](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7&preserve-view=true)
- [Sample private library publication records](samplePrivateLibraryData.json)
- [Sample entity linking Powershell script](linkPrivateLibraryData.ps1)

## Determine entity linking strategy

Once we know what entity we want to link our data against, we can determine what's the appropriate linking strategy. In abstract, we'll leverage MAKES' [natural language processing](concepts-queries.md) capability via Interpret API to link entities.

MAKES' default grammar supports matching natural language queries against various paper attributes (i.e. title, author names, fields of study, title/abstract terms, etc.), resulting in a query expression which can be used to retrieve corresponding paper entities. You can leverage the Interpret test page to explore what type of query makes the most sense for your scenario.

In this tutorial, our sample library data includes a title so we can leverage MAKES' paper title search capability to link our data. We achieve this by sending Interpret requests to a MAKES instance with the query being **title: [library paper title]** as the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

You can also link different types of entities together with the default grammar. For example, you can link author data with MAKES papers by sending Interpret requests with the following query format "**[author name] [affiliation name]**".

You can also build a custom grammar to better fit your linking scenario. See [How to define a custom grammar](how-to-grammar.md) and [How to compile and test a custom grammar](how-to-grammar-build.md) for more detail

## Set appropriate confidence score for linking

Lastly, we'd have to determine an acceptable confidence score to link entities. Interpret API returns a log probability associated with each interpretation. This log probability can be seen as a "confidence score" for the given interpretation. Since the probability for an interpretation can range from 0 to 1, the log probability for an interpretation can be anywhere from negative infinity to 0.

The interpretation log probability also included the log probability of the top matching entity. To get the pure interpretation log probability without considering the interpreted entity, we must subtract the entity log probability from the interpretation log probability.

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_log_probability_as_confidence_score":::

The default MAKES grammar has various penalties associated with not matching paper titles directly. For example, a word matching a paper's fields of study instead of a title word will result a penalty of -1. The steepest penalty, -25 is not being able to match a word against any paper title or abstract. The sample entity linking script uses **-50** as the cut off confidence score for linking data. This allows for some penalization for entity linking, such as two title word mismatch.

Depending on your linking strategy, you may have to set a different score. You may also want to design a custom grammar create a better scoring system for your scenario.

## Choose MAKES entity attributes to include

We start by determining which MAKES entity type we want to link our data against and what attributes can help enrich our private data. See the [MAKES Entity Schema](reference-makes-api-entity-schema.md) to explore the different types and entities and attributes available in MAKES' default index.

In this tutorial, the sample private library publication records is minimal, with each record only containing a paper title and fake library URL. The goal of the tutorial is to augment the minimal library paper records with additional metadata from MAKES, enabling a robust semantic/keyword search experience.

In the sample entity linking Powershell script, we will leverage paper entity's DOI, citation count, abstract, fields of study, authors, affiliations, journal, and conference information to enrich our data and support semantic/keyword search.

We retrieve these information by constructing an Interpret request foreach link attempt with those attributes as the following:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_interpret_request":::

Once we're able to link a library paper against a MAKES paper entity successfully, we will then merge the entities together using the following helper function:

:::code language="powershell" source="linkPrivateLibraryData.ps1" id="snippet_merge_entities":::

## Run sample solution to see entity linking in action

1. Deploy a MAKES instance by following [Create API Instance](get-started-create-api-instances.md) guide
1. Download [Sample Library Data](samplePrivateLibraryData.json)
1. Download [Sample Entity Linking Script](linkPrivateLibraryData.ps1)
1. Modify the entity linking script and set the **makesEndpoint** variable to your deployed MAKES instance url
1. Open up a powershell console and run the sample entity linking script. Make sure the sample library data and linking script are under the same directory.

The sample entity linking script output should look like the following:

Linked | ConfidenceScore | OriginalTitle | MagTitle
---- | ---- |---- |----
True | 0 | Microsoft Academic Graph: When experts are not enough | Microsoft Academic Graph: When experts are not enough                                                                                                                     True | 0 | An Overview of Microsoft Academic Service (MAS) and Applications | An Overview of Microsoft Academic Service (MAS) and Applications                                                                                               False | -137 | The impact of support system of enterprise organization on Taiwanese expatriates’ work-family conflict | Koha enterprise resource planning system and its potential impact on information management organizations            True | 0 | Organisational justice and customer citizenship behaviour of retail industries | Organisational justice and customer citizenship behaviour of retail industries                                                                   True | 0 | A Scalable Hybrid Research Paper Recommender System for Microsoft Academic | A Scalable Hybrid Research Paper Recommender System for Microsoft Academic
True | 0 | Network Embedding as Matrix Factorization: Unifying DeepWalk, LINE, PTE, and node2vec | Network Embedding as Matrix Factorization: Unifying DeepWalk, LINE, PTE, and node2vec
True | 0 | Autonomous Thermalling as a Partially Observable Markov Decision Process (Extended Version) | Autonomous Thermalling as a Partially Observable Markov Decision Process (Extended Version).
True | 0 | CORD-19: The Covid-19 Open Research Dataset | CORD-19: The Covid-19 Open Research Dataset.
False | -65 | Cultural Intelligence, Trait Competitiveness and Multicultural Team Experiences | Cultural Intelligence: Antecedents and Propensity to Accept a Foreign-Based Job Assignment
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
True | -42 | The Mediating Mechanisms between Prosocial Motivation and Job Performance in Mission-driven Organizations | The mediating effect of calling and job involvement on prosocial motivation and performance
False | -85 | Age and Gender Differences in Playfulness and Innovation Behavior among Professional Workers | THE INFLUENCE OF GENDER, AGE AND PROFESSION- RELATED DIFFERENCES ON THE VERBAL BEHAVIOR OF THE SUBJECTS OF ASSOCIATION
True | -3 | Factors affecting training transfer | Factors Affecting Motivation to Transfer Training.
True | 0 | A Review of Microsoft Academic Services for Science of Science Studies | A Review of Microsoft Academic Services for Science of Science Studies
False | -60 | Survey on corporate motivations for culture and arts sponsorship | The Art of Co-Creative Media: An Australian Survey
False | -309 | The Relationship among Transformational Leadership, Public Administrative Ethic and Organizational Citizenship Behavior: An empirical sturdy for tax bureau district office of Kaohsiung | Sharing The Fire: The igniting role of transformational leadership on the relationship between public managers’ and employees’ organizational commitment
False | -81 | The relationship between Advisors’ Leadership Behaviors and Graduate Students’ Achievement Motives | The Relationship between Transformational Leadership Behaviors of Faculty Supervisors and Self-Efficacies of Graduate Assistants.
False | -186 | The Effects of Budgetary Goal Difficulty, Task Uncertainty and Budgetary Emphasis on Performance: Moderated Regression Analysis | THE JOINT EFFECTS OF BUDGETARY SLACK AND TASK UNCERTAINTY ON SUBUNIT PERFORMANCE
False | -95 | Promoting Participation in Performing Arts Activities through Internet Technology: A Case Study in Taiwan. | Enhancing students' learning experience and promoting inclusive practice via social media

## Next steps

Advance to the next section to learn how to design a MAKES schema to enable filter and search for the library data.
