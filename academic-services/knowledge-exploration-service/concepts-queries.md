---
title: Natural Language Queries
description: 
ms.topic: reference
ms.date: 2020-02-07
---

# How MAKES generates semantic interpretations of natural language queries

This article describes how MAKES generates semantic interpretations of a natural language query that enable entities to be retrieved. It is intended for developers using MAKES who require a deeper understanding of the architecture and techniques used.

## Architecture overview and diagram

Processing a natural language query starts with a lexical analysis of the query, with an Academic Language Analyzer component rewriting the query to ensure optimal matching against indexed attribute values. The rewritten query is then parsed using a Context Sensitive Grammar (CSG), with query segmentation 

## Comparison with full text search

An important part of what differentiates MAKES from traditional full text search engines (i.e. Lucene) is how it approaches query analysis and parsing.

Traditional full text search is broken into four stages:

1. Query parsing
1. Lexical analysis
1. Document retrieval
1. Scoring

MAKES requires the use of a Speech Recognition Langage

:::image type="content" source="media/concept-semantic-interpretation-flow.png" alt-text="MAKES Semantic Interpretation Generation Architecture":::

"John Platt Nature 2019"

## Stage 1: Lexical analysis

"john platt nature 2019"

## Stage 2: Context sensitive grammar

To generate semantic interpretations of natural language queries, MAKES leverages 

Hypothesis round #1:
""

Score | Attribute | Query terms
--- | --- | ---
-15.6 | Author name | john platt
-18.5 | Author last name | john
-20.5 | Title keyword | john

Hypotheis 

* ~~[journal] john~~
* ~~[institution] john~~
* ...

MAKES uses best first
"john platt" =>
* Author name "john platt" =>
  * Journal name "nature" =>
    * Year "2019"
  * Title word "nature"
* Author name "john r platt"
* Author name "john d platt"
* Title word "john" and title word "platt"

"john platt

Execute query using language grammar


"wei wang microsoft ai gps trajectories"

- Step 1: Generate semantic interpretations

Parsed | Interpretation | Expression | Documents
--- | --- | --- | ---
"" | * | All() | ~220 million
"wei wang" | Composite(AA.AuN='wei wang')
- Step 2: Evaluate structured query expressions
natural language query
