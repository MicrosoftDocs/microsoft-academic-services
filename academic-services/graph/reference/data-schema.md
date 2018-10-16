---
title: MAG entity data schema
description: Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute
ms.topic: reference
ms.date: 10/15/2018
---
# Microsoft Academic Graph data schema

Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute.

## Open Data License: [ODC-BY](https://opendatacommons.org/licenses/by/1.0/)

When using Microsoft Academic data (MAG, MAKES, etc.) in a product or service, or including data in a redistribution, please acknowledge Microsoft Academic using the URI https://aka.ms/msracad. For publications and reports, please cite the following article:

> Arnab Sinha, Zhihong Shen, Yang Song, Hao Ma, Darrin Eide, Bo-June (Paul) Hsu, and Kuansan Wang. 2015. An Overview of Microsoft Academic Service (MA) and Applications. In Proceedings of the 24th International Conference on World Wide Web (WWW '15 Companion). ACM, New York, NY, USA, 243-246. DOI=http://dx.doi.org/10.1145/2740908.2742839

## Note on "rank"

“Rank” values in the entity files are the log probability of an entity being important multiplied by a constant(-1000), i.e.:

> Rank = -1000 * Ln( probability of an entity being important )

## Affiliations.txt

Column # | Description | Type
--- | --- | ---
1 | Affiliation ID | long
2 | Rank | uint
3 | Normalized name | string
4 | Display name | string
5 | Grid ID | string
6 | Official page | string
7 | Wiki page | string
8 | Paper count | long
9 | Citation count | long
10 | Created date | DateTime

## Authors.txt

Column # | Description | Type
--- | --- | ---
1 | Author ID | long
2 | Rank | uint
3 | Normalized name | string
4 | Display name | string
5 | Last known affiliation ID | long?
6 | Paper count | long
7 | Citation count | long
8 | Created date | DateTime

## ConferenceInstances.txt

Column # | Description | Type
--- | --- | ---
1 | Conference instance ID | long
2 | Normalized name | string
3 | Display name | string
4 | Conference series ID | long
5 | Location | string
6 | Official URL | string
7 | Start date | DateTime?
8 | End date | DateTime?
9 | Abstract registration date | DateTime?
10 | Submission deadline date | DateTime?
11 | Notification due date | DateTime?
12 | Final version due date | DateTime?
13 | Paper count | long
14 | Citation count | long
15 | Created date | DateTime

## ConferenceSeries.txt

Column # | Description | Type
--- | --- | ---
1 | Conference series ID | long
2 | Rank | uint
3 | Normalized name | string
4 | Display name | string
5 | Paper count | long
6 | Citation count | long
7 | Created date | DateTime

## FieldsOfStudy.txt

Column # | Description | Type
--- | --- | ---
1 | Field of study ID | long
2 | Rank | uint
3 | Normalized name | string
4 | Display name | string
5 | Main type | string
6 | Level | Int
7 | Paper count | long
8 | Citation count | long
9 | Created date | DateTime

## FieldsOfStudyChildren.txt

Column # | Description | Type
--- | --- | ---
1 | Field of study ID | long
2 | Child field of study ID | long

## RelatedFieldOfStudy.txt

Column # | Description | Type
--- | --- | ---
1 | Field of study ID 1 | long
2 | Display name 1 | string
3 | Type 1 | string
4 | Field of study ID 2 | long
5 | Display name 2 | string
6 | Type 2 | string
7 | Rank | float

## Journals.txt

Column # | Description | Type
--- | --- | ---
1 | Journal ID | long
2 | Rank | uint
3 | Normalized name | string
4 | Display name | string
5 | ISSN | string
6 | Publisher | string
7 | Web page | string
8 | Paper count | long
9 | Citation count | long
10 | Created date | DateTime

## Papers.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Rank | uint
3 | DOI | string
4 | Doc type | string
5 | Paper title | string
6 | Original title | string
7 | Book title | string
8 | Year | int
9 | Date | DateTime?
10 | Publisher | string
11 | Journal ID | long?
12 | Conference series ID | long?
13 | Conference instance ID | long?
14 | Volume | string
15 | Issue | string
16 | First page | string
17 | Last page | string
18 | Reference count | long
19 | Citation count | long
20 | Estimated citation count | long
21 | Created date | DateTime

## PaperAbstractInvertedIndex.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Indexed abstract | string

## PaperAuthorAffiliations.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Author ID | long
3 | Affiliation ID | long?
4 | Author sequence number | uint
5 | Original Affiliation | string

## PaperCitationContexts.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Paper reference ID | long
3 | Citation context | string

## PaperFieldsOfStudy.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Field of study ID | long
3 | Score | float

## PaperLanguages.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Language code | string

## PaperRecommendations.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Recommended paper ID | long
3 | Score | float

## PaperReferences.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Paper reference ID | long

## PaperUrls.txt

Column # | Description | Type
--- | --- | ---
1 | Paper ID | long
2 | Source type | int?
3 | Source URL | string