---
title: Microsoft Academic Graph data schema
description: Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute
ms.topic: reference
ms.date: 8/19/2019
---
# Microsoft Academic Graph data schema

Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute.

## Open Data License: [ODC-BY](https://opendatacommons.org/licenses/by/1.0/)

When using Microsoft Academic data (MAG, MAKES, etc.) in a product or service, or including data in a redistribution, please acknowledge Microsoft Academic using the URI https://aka.ms/msracad. For publications and reports, please cite the following article:

> [!NOTE]
> Arnab Sinha, Zhihong Shen, Yang Song, Hao Ma, Darrin Eide, Bo-June (Paul) Hsu, and Kuansan Wang. 2015. An Overview of Microsoft Academic Service (MA) and Applications. In Proceedings of the 24th International Conference on World Wide Web (WWW '15 Companion). ACM, New York, NY, USA, 243-246. DOI=http://dx.doi.org/10.1145/2740908.2742839

## Entity Relationship Diagram

 [![Entity Relationship Diagram](media/erd/entity-relationship-diagram-thumbnail.png)](media/erd/entity-relationship-diagram.png)

## Note on "rank"

“Rank” values in the entity files are the log probability of an entity being important multiplied by a constant(-1000), i.e.:

> [!NOTE]
> Rank = -1000 * Ln( probability of an entity being important )

## Affiliations

**Path**: mag/Affiliations.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | AffiliationId | long | PRIMARY KEY
2 | Rank | uint |
3 | NormalizedName | string |
4 | DisplayName | string |
5 | GridId | string |
6 | OfficialPage | string |
7 | WikiPage | string |
8 | PaperCount | long |
9 | CitationCount | long |
10 | Latitude | float? |
11 | Longitude | float? |
12 | CreatedDate | DateTime |

## Authors

**Path**: mag/Authors.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | AuthorId | long | PRIMARY KEY
2 | Rank | uint |
3 | NormalizedName | string |
4 | DisplayName | string |
5 | LastKnownAffiliationId | long? |
6 | PaperCount | long |
7 | CitationCount | long |
8 | CreatedDate | DateTime |

## Conference Instances

**Path**: mag/ConferenceInstances.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | ConferenceInstanceId | long | PRIMARY KEY
2 | NormalizedName | string |
3 | DisplayName | string |
4 | ConferenceSeriesId | long | FOREIGN KEY REFERENCES ConferenceSeries(ConferenceSeriesId)
5 | Location | string |
6 | OfficialUrl | string |
7 | StartDate | DateTime? |
8 | EndDate | DateTime? |
9 | AbstractRegistrationDate | DateTime? |
10 | SubmissionDeadlineDate | DateTime? |
11 | NotificationDueDate | DateTime? |
12 | FinalVersionDueDate | DateTime? |
13 | PaperCount | long |
14 | CitationCount | long |
15 | Latitude | float? |
16 | Longitude | float? |
17 | CreatedDate | DateTime |

## Conference Series

**Path**: mag/ConferenceSeries.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | ConferenceSeriesId | long | PRIMARY KEY
2 | Rank | uint |
3 | NormalizedName | string |
4 | DisplayName | string |
5 | PaperCount | long |
6 | CitationCount | long |
7 | CreatedDate | DateTime |

## Entity Related Entities

**Path**: advanced/EntityRelatedEntities.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | EntityId | long |
2 | EntityType | string | af: Affiliation <br> j: Journal <br> c: Conference
3 | RelatedEntityId | long |
4 | RelatedEntityType | string | af: Affiliation <br> j: Journal <br> c: Conference
5 | RelatedType | int | 0: Two entities are similar if they appear on the same paper <br> 1: Two entities are similar if they have common coauthors <br> 2: Two entities are similar if they are co-cited by others <br> 3: Two entities are similar if they have common fields of study <br> 4: Two entities are similar if they appear in the same venue <br> 5: Entity A is similar to entity B if A cites B <br> 6: Entity A is similar to entity B if A is cited by B
6 | Score | float | Confidence range between 0 and 1. Bigger number representing higher confidence.

## Field Of Study Children

**Path**: advanced/FieldOfStudyChildren.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)
2 | ChildFieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)

## Field Of Study Extended Attributes

**Path**: advanced/FieldOfStudyExtendedAttributes.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)
2 | AttributeType | int | 1: UMLSId <br> 2: SourceUrl
3 | AttributeValue | string |

## Fields Of Study

**Path**: advanced/FieldsOfStudy.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | PRIMARY KEY
2 | Rank | uint |
3 | NormalizedName | string |
4 | DisplayName | string |
5 | MainType | string |
6 | Level | Int | 0 - 5
7 | PaperCount | long |
8 | CitationCount | long |
9 | CreatedDate | DateTime |

## Journals

**Path**: mag/Journals.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | JournalId| long | PRIMARY KEY
2 | Rank | uint |
3 | NormalizedName | string |
4 | DisplayName | string |
5 | Issn | string |
6 | Publisher | string |
7 | Webpage | string |
8 | PaperCount | long |
9 | CitationCount | long |
10 | CreatedDate | DateTime |

## Paper Abstracts Inverted Index

**Path**: nlp/PaperAbstractsInvertedIndex.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | IndexedAbstract | string | See [Microsoft Academic Graph FAQ](resources-faq.md#what-format-are-paper-abstracts-published-in)

## Paper Author Affiliations

**Path**: mag/PaperAuthorAffiliations.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers(PaperId)
2 | AuthorId | long | FOREIGN KEY REFERENCES Authors(AuthorId)
3 | AffiliationId | long? | FOREIGN KEY REFERENCES Affiliations(AffiliationId)
4 | AuthorSequenceNumber | uint | 1-based author sequence number. 1: the 1st author listed on paper.
5 | OriginalAuthor | string |
6 | OriginalAffiliation | string |

> [!NOTE]
> It is possible to have multiple rows with same (PaperId, AuthorId, AffiliationId) when an author is associated with multiple affiliations.

## Paper Citation Contexts

**Path**: nlp/PaperCitationContexts.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers(PaperId)
2 | PaperReferenceId | long | FOREIGN KEY REFERENCES Papers(PaperId)
3 | CitationContext | string |

## Paper Extended Attributes

**Path**: mag/PaperExtendedAttributes.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers(PaperId)
2 | AttributeType | int | 1: PatentId <br> 2: PubMedId <br> 3: PmcId
3 | AttributeValue | string |

## Paper Fields Of Study

**Path**: advanced/PaperFieldsOfStudy.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | FieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)
3 | Score | float | Confidence range between 0 and 1. Bigger number representing higher confidence.

## PaperLanguages.txt

**Path**: nlp/PaperLanguages.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | LanguageCode | string | PRIMARY KEY

## Paper Recommendations

**Path**: advanced/PaperRecommendations.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | RecommendedPaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
3 | Score | float | Confidence range between 0 and 1. Bigger number representing higher confidence.

## Paper References

**Path**: mag/PaperReferences.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | PaperReferenceId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)

## Paper Resources

**Path**: mag/PaperResources.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers(PaperId)
2 | ResourceType | int | Bit flags. 1 = Project, 2 = Data, 4 = Code
3 | ResourceUrl | string |
4 | SourceUrl | string |
5 | RelationshipType | int | Bit flags. 1 = Own, 2 = Cite

## Paper Urls

**Path**: mag/PaperUrls.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers(PaperId)
2 | SourceType | int? | 1 = Html, 2 = Text, 3 = Pdf, 4 = Doc, 5 = Ppt, 6 = Xls, 8 = Rtf, 12 = Xml, 13 = Rss, 20 = Swf, 27 = Ics, 31 = Pub, 33 = Ods, 34 = Odp, 35 = Odt, 36 = Zip, 40 = Mp3, 0/999/NULL = unknown
3 | SourceUrl | string | PRIMARY KEY

## Papers

**Path**: mag/Papers.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY
2 | Rank | uint |
3 | Doi | string |
4 | DocType | string | Book, BookChapter, Conference, Dataset, Journal, Patent, NULL : unknown
5 | PaperTitle | string |
6 | OriginalTitle | string |
7 | BookTitle | string |
8 | Year | int? |
9 | Date | DateTime? |
10 | Publisher | string |
11 | JournalId | long? | FOREIGN KEY REFERENCES Journals(JournalId)
12 | ConferenceSeriesId | long? | FOREIGN KEY REFERENCES ConferenceSeries(ConferenceSeriesId)
13 | ConferenceInstanceId | long? | FOREIGN KEY REFERENCES ConferenceInstances(ConferenceInstanceId)
14 | Volume | string |
15 | Issue | string |
16 | FirstPage | string |
17 | LastPage | string |
18 | ReferenceCount | long |
19 | CitationCount | long |
20 | EstimatedCitation | long |
21 | OriginalVenue | string |
22 | FamilyId | long? | Papers with same FamilyId are same papers published in different venues
23 | CreatedDate | DateTime |

## Related Field Of Study

**Path**: advanced/RelatedFieldOfStudy.txt

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId1 | long | FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)
2 | Type1 | string | general, disease, disease_cause, medical_treatment, symptom
3 | FieldOfStudyId2 | long | FOREIGN KEY REFERENCES FieldsOfStudy(FieldOfStudyId)
4 | Type2 | string | general, disease, disease_cause, medical_treatment, symptom
5 | Rank | float | Confidence range between 0 and 1. Bigger number representing higher confidence.
