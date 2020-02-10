---
title: MAKES API entity schema
description: Learn about the entity schema that MAKES API/Index contains.
ms.topic: conceptual
ms.date: 2020-02-10
---

# Entity schema

The academic graph is composed of 7 types of entity. All entities will have an Entity ID and an Entity type.

## Common Entity Attributes

Name    |Description    |Type    | Operations
------- | ------------- | -------| ---------------
Id      |Entity ID      |Int64   |Equals
Ty      |Entity type    |enum    |Equals

### Entity type enum

Name    |value
--------|-------
[Paper](#Paper-Entity) |0
[Author](#Author-Entity) |1
[Journal](#Journal-Entity) |2
[Conference Series](#Conference-Series-Entity) |3
[Conference Instance](#Conference-Instance-Entity) |4
[Affiliation](#Affiliation-Entity) |5
[Field Of Study](#Field-Of-Study-Entity) |6

## Paper Entity

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
BT | BibTex document type ('a':Journal article, 'b':Book, 'c':Book chapter, 'p':Conference paper) | String | None
BV | BibTex venue name | String | None
C.CId | Conference series ID | Int64 | Equals
C.CN | Conference series name | String | Equals, StartsWith
CC | Citation count | Int32 | None  
CitCon | Citation contexts</br></br>List of referenced paper ID’s and the corresponding context in the paper (e.g. [{123:["brown foxes are known for jumping as referenced in paper 123", "the lazy dogs are a historical misnomer as shown in paper 123"]}) | Custom | None
D | Date published in YYYY-MM-DD format | Date | Equals, IsBetween
DN | Original paper title | String | None
DOI | Digital Object Identifier | String | Equals, StartsWith
E | Extended metadata</br></br>**IMPORTANT**: This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA) | [Extended](#Paper-Entity-Extended) | None
ECC | Estimated citation count | Int32 | None
F.DFN | Original field of study name | String | None
F.FId | Field of study ID | Int64 | Equals
F.FN | Normalized field of study name | String | Equals, StartsWith
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
W | Unique words in title | String[] | Equals
Y | Year published | Int32 | Equals, IsBetween

### Paper Entity Extended

> [!IMPORTANT]
> This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA)

> [!IMPORTANT]
> Support for requesting individual extended attributes by using the "E." scope, i.e. "E.DN" is being deprecated. While this is still technically supported, requesting individual extended attributes using the "E." scope will result in the attribute value being returned in two places in the JSON response, as part of the "E" object and as a top level attribute.

Name | Description | Type | Operations
--- | --- | --- | ---
BT | BibTex document type ('a':Journal article, 'b':Book, 'c':Book chapter, 'p':Conference paper) | String | None
BV | BibTex venue name | String | None
CC | Citation contexts</br></br>List of referenced paper ID’s and the corresponding context in the paper (e.g. [{123:["brown foxes are known for jumping as referenced in paper 123", "the lazy dogs are a historical misnomer as shown in paper 123"]}) | Custom | None
DN | Original paper title | String | None
DOI | Digital Object Identifier | String | None
FP | First page of paper in publication | String | None
I | Publication issue | String | None
IA | Inverted Abstract | [InvertedAbstract](#invertedabstract) | None
LP | Last page of paper in publication | String | None
PB | Publisher | String | None
S | List of source URLs of the paper, sorted by relevance | [Source](#source)[] | None
V | Publication volume | String | None
VFN | Full name of the Journal or Conference venue | String | None
VSN | Short name of the Journal or Conference venue | String | None

### InvertedAbstract

> [!IMPORTANT]
> InvertedAbstract attributes cannot be directly requested as a return attribute. If you need an individual attribute you must request the top level "IA" attribute, i.e. to get IA.IndexLength request attributes=IA

Name | Description | Type | Operations
--- | --- | --- | ---
IndexLength | Number of items in the index (abstract's word count) | Int32 | None
InvertedIndex | List of abstract words and their corresponding position in the original abstract (e.g. [{"the":[0, 15, 30]}, {"brown":[1]}, {"fox":[2]}]) | Custom | None

### Source

> [!IMPORTANT]
> Source attributes cannot be directly requested as a return attribute. If you need an individual attribute you must request the top level "S" attribute, i.e. to get S.U request attributes=S

Name | Description | Type | Operations
--- | --- | --- | ---
Ty | Source URL type (1:HTML, 2:Text, 3:PDF, 4:DOC, 5:PPT, 6:XLS, 7:PS) | String | None
U | Source URL | String | None

## Author Entity

> [!NOTE]
> Following attributes are specific to author entity. (Ty = '1')

Name | Description | Type | Operations
--- | --- | --- | ---
Id		| Entity ID								|Int64		|Equals
AuN		| Author normalized name					|String		|Equals
CC		| Author total citation count			|Int32		|None  
DAuN	| Author display name					|String		|None
E | Extended metadata</br></br>**IMPORTANT**: This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA) | [Extended](#Author-Entity-Extended) | None
ECC		| Author total estimated citation count	|Int32		|None
LKA.AfId | Entity ID of the last known affiliation found for the author | Int64 | None
LKA.AfN | Normalized name of the last known affiliation found for the author | String | None
PC | Author total publication count | Int32 | None

### Author Entity Extended

> [!IMPORTANT]
> This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA)

> [!IMPORTANT]
> Support for requesting individual extended attributes by using the "E." scope, i.e. "E.DN" is being deprecated. While this is still technically supported, requesting individual extended attributes using the "E." scope will result in the attribute value being returned in two places in the JSON response, as part of the "E" object and as a top level attribute.

Name | Description | Type | Operations
--- | --- | --- | ---
LKA.AfId | Entity ID of the last known affiliation found for the author | Int64 | None
LKA.AfN | Normalized name of the last known affiliation found for the author | String | None
PC | Author total publication count | Int32 | None

## Journal Entity

> [!NOTE]
> Following attributes are specific to journal entity. (Ty = '2')

Name | Description | Type | Operations
--- | --- | --- | ---
CC		|Journal total citation count			|Int32		|None  
DJN		|Journal display name				|String		|None
ECC		|Journal total estimated citation count	|Int32		|None
JN		|Journal normalized name					|String		|Equals
Id		|Entity ID								|Int64		|Equals
PC    |Journal total publication count | Int32 | None

## Conference Series Entity

> [!NOTE]
> Following attributes are specific to conference series entity. (Ty = '3')

Name | Description | Type | Operations
--- | --- | --- | ---
CC		|Conference series total citation count			|Int32		|None  
CN		|Conference series normalized name		|String		|Equals
DCN		|Conference series display name 		|String		|None
ECC		|Conference series total estimated citation count	|Int32		|None
F.FId	|Field of study entity ID associated with the conference series |Int64 	| Equals
F.FN	|Field of study name associated with the conference series 	| Equals,<br/>StartsWith
Id		|Entity ID								|Int64		|Equals
PC    |Conference series total publication count |Int32 | None

## Conference Instance Entity

> [!NOTE]
> Following attributes are specific to conference instance entity. (Ty = '4')

Name | Description | Type | Operations
--- | --- | --- | ---
CC		|Conference instance total citation count			|Int32		|None  
CD.D	|Date of a conference instance event 	|Date		|Equals, IsBetween
CD.T	|Title of a conference instance event 	|Date		|Equals, IsBetween
CIARD	|Abstract registration due date of the conference instance 	|Date		|Equals, IsBetween
CIED	|End date of the conference instance 	|Date		|Equals, IsBetween
CIFVD	|Final version due date of the conference instance 	|Date		|Equals, IsBetween
CIL		|Location of the conference instance 	|String		|Equals, StartsWith
CIN		|Conference instance normalized name |String		|Equals
CINDD	|Notification date of the conference instance 	|Date		|Equals, IsBetween
CISD	|Start date of the conference instance 	|Date		|Equals, IsBetween
CISDD	|Submission due date of the conference instance 	|Date		|Equals, IsBetween
DCN		|Conference instance display name  |String		|None
E | Extended metadata</br></br>**IMPORTANT**: This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA) | [Extended](#Conference-Instance-Extended) | None
ECC		|Conference instance total estimated citation count	|Int32		|None
FN | Conference instance full name | String | None
Id		|Entity ID								|Int64		|Equals
PC | Conference instance total publication count | Int32 | None
PCS.CN	|Parent conference series name of the instance |String 	|Equals
PCS.CId	|Parent conference series ID of the instance |Int64 	|Equals

### Conference Instance Extended

> [!IMPORTANT]
> This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA)

> [!IMPORTANT]
> Support for requesting individual extended attributes by using the "E." scope, i.e. "E.DN" is being deprecated. While this is still technically supported, requesting individual extended attributes using the "E." scope will result in the attribute value being returned in two places in the JSON response, as part of the "E" object and as a top level attribute.

Name | Description | Type | Operations
--- | --- | --- | ---
FN | Conference instance full name | String | None
PC | Conference instance total publication count | Int32 | None

## Affiliation Entity

> [!NOTE]
> Following attributes are specific to affiliation entity. (Ty = '5')

Name | Description | Type | Operations
--- | --- | --- | ---
AfN | Affiliation normalized name |String |Equals
CC | Affiliation total citation count |Int32		|none  
DAfN | Affiliation display name |String |none
E | Extended metadata</br></br>**IMPORTANT**: This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA) | [Extended](#Affiliation-Entity-Extended) | None
ECC | Affiliation total estimated citation count |Int32 |none
Id | Entity ID |Int64 |Equals
PC | Total number of publications written in affiliation with this entity | Int32 | None

### Affiliation Entity Extended

> [!IMPORTANT]
> This attribute has been deprecated and is only supported for legacy applications. Requesting this attribute individually (i.e. attributes=Id,Ti,E) will result in all extended metadata attributes being returned in a *serialized JSON string*</br></br>All attributes contained in the extended metadata are now available as a top-level attribute and can be requested as such (i.e. attributes=Id,Ti,DOI,IA)

> [!IMPORTANT]
> Support for requesting individual extended attributes by using the "E." scope, i.e. "E.DN" is being deprecated. While this is still technically supported, requesting individual extended attributes using the "E." scope will result in the attribute value being returned in two places in the JSON response, as part of the "E" object and as a top level attribute.

Name | Description | Type | Operations
--- | --- | --- | ---
PC | Total number of publications written in affiliation with this entity | Int32 | None

## Field Of Study Entity

> [!NOTE]
> Following attributes are specific to field of study entity. (Ty = '6')

Name | Description | Type | Operations
--- | --- | --- | ---
CC		|Field of study total citation count	|Int32		|None  
DFN 	|Field of study display name			|String		|None
ECC		|Field of total estimated citation count|Int32		|None
FL		|Level in fields of study hierarchy 	|Int32		|Equals, IsBetween
FN		|Field of study normalized name			|String		|Equals
FC.FId 	|Child field of study ID 				|Int64 		|Equals
FC.FN	|Child field of study name 		    	|String		|Equals
FP.FId 	|Parent field of study ID 				|Int64 		|Equals
FP.FN	|Parent field of study name 			|String		|Equals
Id		|Entity ID								|Int64		|Equals
PC    | Field of study total publication count | Int32 | None
