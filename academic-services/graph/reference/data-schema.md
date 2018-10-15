---
title: Microsoft Academic Graph data schema
description: Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute
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

Description | Type
--- | ---
Affiliation ID | long
Rank | uint
Normalized name | string
Display name | string
Grid ID | string
Official page | string
Wiki page | string
Paper count | long
Citation count | long
Created date | DateTime

## Authors.txt

Description | Type
--- | ---
Author ID | long
Rank | uint
Normalized name | string
Display name | string
Last known affiliation ID | long?
Paper count | long
Citation count | long
Created date | DateTime

## ConferenceInstances.txt

Description | Type
--- | ---
Conference instance ID | long
Normalized name | string
Display name | string
Conference series ID | long
Location | string
Official URL | string
Start date | DateTime?
End date | DateTime?
Abstract registration date | DateTime?
Submission deadline date | DateTime?
Notification due date | DateTime?
Final version due date | DateTime?
Paper count | long
Citation count | long
Created date | DateTime

## ConferenceSeries.txt

Description | Type
--- | ---
Conference series ID | long
Rank | uint
Normalized name | string
Display name | string
Paper count | long
Citation count | long
Created date | DateTime

## FieldsOfStudy.txt

Description | Type
--- | ---
Field of study ID | long
Rank | uint
Normalized name | string
Display name | string
Main type | string
Level | Int
Paper count | long
Citation count | long
Created date | DateTime

## FieldsOfStudyChildren.txt

Description | Type
--- | ---
Field of study ID | long
Child field of study ID | long

## RelatedFieldOfStudy.txt

Description | Type
--- | ---
Field of study ID 1 | long
Display name 1 | string
Type 1 | string
Field of study ID 2 | long
Display name 2 | string
Type 2 | string
Rank | float

## Journals.txt

Description | Type
--- | ---
Journal ID | long
Rank | uint
Normalized name | string
Display name | string
ISSN | string
Publisher | string
Web page | string
Paper count | long
Citation count | long
Created date | DateTime

## Papers.txt

Description | Type
--- | ---
Paper ID | long
Rank | uint
DOI | string
Doc type | string
Paper title | string
Original title | string
Book title | string
Year | int
Date | DateTime?
Publisher | string
Journal ID | long?
Conference series ID | long?
Conference instance ID | long?
Volume | string
Issue | string
First page | string
Last page | string
Reference count | long
Citation count | long
Estimated citation count | long
Created date | DateTime

## PaperAbstractInvertedIndex.txt

Description | Type
--- | ---
Paper ID | long
Indexed abstract | string

## PaperAuthorAffiliations.txt

Description | Type
--- | ---
Paper ID | long
Author ID | long
Affiliation ID | long?
Author sequence number | uint
Original Affiliation | string

## PaperCitationContexts.txt

Description | Type
--- | ---
Paper ID | long
Paper reference ID | long
Citation context | string

## PaperFieldsOfStudy.txt

Description | Type
--- | ---
Paper ID | long
Field of study ID | long
Score | float

## PaperLanguages.txt

Description | Type
--- | ---
Paper ID | long
Language code | string

## PaperRecommendations.txt

Description | Type
--- | ---
Paper ID | long
Recommended paper ID | long
Score | float

## PaperReferences.txt

Description | Type
--- | ---
Paper ID | long
Paper reference ID | long

## PaperUrls.txt

Description | Type
--- | ---
Paper ID | long
Source type | int?
Source URL | string