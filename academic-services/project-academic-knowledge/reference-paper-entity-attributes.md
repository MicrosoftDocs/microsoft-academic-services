---
title: Paper entity attributes
description: Learn the attributes you can use with paper entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 2020-04-10
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Paper Entity

> [!NOTE]
> Below attributes are specific to paper entity. (Ty = '0')

Name | Description | Type | Operations
--- | --- | --- | ---
AA.AfId | Author affiliation ID | Int64 | Equals
AA.AfN | Author affiliation name | String | Equals, StartsWith
AA.AuId | Author ID | Int64 | Equals
AA.AuN | Normalized author name | String | Equals, StartsWith
AA.DAuN | Original author name | String | None
AA.DAfN | Original affiliation name | String | None
AA.S | Numeric position in author list | Int32 | Equals
AW | Unique, normalized words in abstract, excluding common/stopwords | String[] | Equals
BT | BibTex document type ('a':Journal article, 'b':Book, 'c':Book chapter, 'p':Conference paper) | String | None
BV | BibTex venue name | String | None
C.CId | Conference series ID | Int64 | Equals
C.CN | Conference series name | String | Equals, StartsWith
CC | Citation count | Int32 | None  
CitCon | Citation contexts</br></br>List of referenced paper ID's and the corresponding context in the paper (e.g. [{123:["brown foxes are known for jumping as referenced in paper 123", "the lazy dogs are a historical misnomer as shown in paper 123"]}) | Custom | None
D | Date published in YYYY-MM-DD format | Date | Equals, IsBetween
DN | Original paper title | String | None
DOI | Digital Object Identifier</br></br>**IMPORTANT**: The DOI is normalized to uppercase letters, so if querying the field via evaluate/histogram ensure that the DOI value is using all uppercase letters | String | Equals, StartsWith
ECC | Estimated citation count | Int32 | None
F.DFN | Original field of study name | String | None
F.FId | Field of study ID | Int64 | Equals
F.FN | Normalized field of study name | String | Equals, StartsWith
FamId | If paper is published in multiple venues (e.g. pre-print and conference) with different paper IDs, this ID represents the main/primary paper ID of the family. The field can be used to find all papers in the family group, i.e. FamId=<paper_id> | Int64 | Equals
FP | First page of paper in publication | String | Equals
I | Publication issue | String | Equals
IA | Inverted abstract | [InvertedAbstract](#invertedabstract) | None
Id | Paper ID | Int64 | Equals
J.JId | Journal ID | Int64 | Equals
J.JN | Journal name | String | Equals, StartsWith
LP | Last page of paper in publication | String | Equals
PB | Publisher | String | None
Pt | Publication type (0:Unknown, 1:Journal article, 2:Patent, 3:Conference paper, 4:Book chapter, 5:Book, 6:Book reference entry, 7:Dataset, 8:Repository | String | Equals
RId | List of referenced paper IDs | Int64[] | Equals
S | List of source URLs of the paper, sorted by relevance | [Source](#source)[] | None
Ti | Normalized title | String | Equals, StartsWith
V | Publication volume | String | Equals
VFN | Full name of the Journal or Conference venue | String | None
VSN | Short name of the Journal or Conference venue | String | None
W | Unique, normalized words in title | String[] | Equals
Y | Year published | Int32 | Equals, IsBetween

## InvertedAbstract

> [!IMPORTANT]
> InvertedAbstract attributes cannot be directly requested as a return attribute. If you need an individual attribute you must request the top level "IA" attribute, i.e. to get IA.IndexLength request attributes=IA

Name | Description | Type | Operations
--- | --- | --- | ---
IndexLength | Number of items in the index (abstract's word count) | Int32 | None
InvertedIndex | List of abstract words and their corresponding position in the original abstract (e.g. [{"the":[0, 15, 30]}, {"brown":[1]}, {"fox":[2]}]) | Custom | None

## Source

> [!IMPORTANT]
> Source attributes cannot be directly requested as a return attribute. If you need an individual attribute you must request the top level "S" attribute, i.e. to get S.U request attributes=S

Name | Description | Type | Operations
--- | --- | --- | ---
Ty | Source URL type (1:HTML, 2:Text, 3:PDF, 4:DOC, 5:PPT, 6:XLS, 7:PS) | String | None
U | Source URL | String | None
