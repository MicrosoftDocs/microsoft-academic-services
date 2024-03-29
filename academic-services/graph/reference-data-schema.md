---
title: Microsoft Academic Graph data schema
description: Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute
ms.topic: reference
ms.date: 5/28/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Microsoft Academic Graph data schema

Documents the complete, most recent Microsoft Academic Graph entity data schema, including the name and type of each attribute.

## Open Data License: [ODC-BY](https://opendatacommons.org/licenses/by/1.0/)

When using Microsoft Academic data (MAG, MAKES, etc.) in a product or service, or including data in a redistribution, please acknowledge Microsoft Academic using the URI https://aka.ms/msracad. For publications and reports, please cite following articles:

> [!NOTE]
>
> - Arnab Sinha, Zhihong Shen, Yang Song, Hao Ma, Darrin Eide, Bo-June (Paul) Hsu, and Kuansan Wang. 2015. An Overview of Microsoft Academic Service (MA) and Applications. In Proceedings of the 24th International Conference on World Wide Web (WWW '15 Companion). ACM, New York, NY, USA, 243-246, doi: 10.1145/2740908.2742839
>
> - K. Wang et al., “A Review of Microsoft Academic Services for Science of Science Studies”, Frontiers in Big Data, 2019, doi: 10.3389/FDATA.2019.00045

## Entity Relationship Diagram

 [![Entity Relationship Diagram](media/erd/entity-relationship-diagram.png)](media/erd/entity-relationship-diagram.png)

## Affiliations

**Path** `mag/Affiliations.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | AffiliationId | long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | NormalizedName | string |
4 | DisplayName | string |
5 | GridId | string |
6 | OfficialPage | string |
7 | WikiPage | string |
8 | PaperCount | long |
9 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
10 | CitationCount | long |
11 | Iso3166Code | string | Two-letter codes (alpha-2) defined in [ISO_3166 Code (ISO.org)](https://www.iso.org/iso-3166-country-codes.html) and [ISO 3166-2 (Wiki)](https://en.wikipedia.org/wiki/ISO_3166-2). Example: US
12 | Latitude | float? | 
13 | Longitude | float? |
14 | CreatedDate | DateTime |

## AuthorExtendedAttributes

**Path** `mag/AuthorExtendedAttributes.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | AuthorId | long | FOREIGN KEY REFERENCES Authors.AuthorId
2 | AttributeType | int | 1: Alternative Name
3 | AttributeValue | string |

## Authors

**Path** `mag/Authors.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | AuthorId | long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | NormalizedName | string |
4 | DisplayName | string |
5 | LastKnownAffiliationId | long? |
6 | PaperCount | long |
7 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
8 | CitationCount | long |
9 | CreatedDate | DateTime |

## Conference Instances

**Path** `mag/ConferenceInstances.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | ConferenceInstanceId | long | PRIMARY KEY
2 | NormalizedName | string |
3 | DisplayName | string |
4 | ConferenceSeriesId | long | FOREIGN KEY REFERENCES ConferenceSeries.ConferenceSeriesId
5 | Location | string |
6 | OfficialUrl | string |
7 | StartDate | DateTime? |
8 | EndDate | DateTime? |
9 | AbstractRegistrationDate | DateTime? |
10 | SubmissionDeadlineDate | DateTime? |
11 | NotificationDueDate | DateTime? |
12 | FinalVersionDueDate | DateTime? |
13 | PaperCount | long |
14 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
15 | CitationCount | long |
16 | Latitude | float? |
17 | Longitude | float? |
18 | CreatedDate | DateTime |

## Conference Series

**Path** `mag/ConferenceSeries.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | ConferenceSeriesId | long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | NormalizedName | string |
4 | DisplayName | string |
5 | PaperCount | long |
6 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
7 | CitationCount | long |
8 | CreatedDate | DateTime |

## Entity Related Entities

**Path** `advanced/EntityRelatedEntities.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | EntityId | long |
2 | EntityType | string | af: Affiliation <br> j: Journal <br> c: Conference
3 | RelatedEntityId | long |
4 | RelatedEntityType | string | af: Affiliation <br> j: Journal <br> c: Conference
5 | RelatedType | int | 0: Two entities are similar if they appear on the same paper <br> 1: Two entities are similar if they have common coauthors <br> 2: Two entities are similar if they are co-cited by others <br> 3: Two entities are similar if they have common fields of study <br> 4: Two entities are similar if they appear in the same venue <br> 5: Entity A is similar to entity B if A cites B <br> 6: Entity A is similar to entity B if A is cited by B
6 | Score | float | Confidence range between 0 and 1. Larger number representing higher confidence.

## Field of Study Children

**Path** `advanced/FieldOfStudyChildren.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId
2 | ChildFieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId

## Field of Study Extended Attributes

**Path** `advanced/FieldOfStudyExtendedAttributes.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId
2 | AttributeType | int | 1: AUI: Atom Unique Identifier defined in [Unified Medical Language System (UMLS)](https://www.nlm.nih.gov/research/umls/new_users/glossary.html#a), version [2018AA](https://www.nlm.nih.gov/research/umls/licensedcontent/umlsarchives04.html#2018AA). <br> 2: SourceUrl <br> 3: CUI: Concept Unique Identifier defined in [Unified Medical Language System (UMLS)](https://www.nlm.nih.gov/research/umls/new_users/glossary.html#c), version [2020AB](https://www.nlm.nih.gov/research/umls/licensedcontent/umlsknowledgesources.html).
3 | AttributeValue | string |

## Fields of Study

**Path** `advanced/FieldsOfStudy.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId | long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | NormalizedName | string |
4 | DisplayName | string |
5 | MainType | string |
6 | Level | Int | 0 - 5
7 | PaperCount | long |
8 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
9 | CitationCount | long |
10 | CreatedDate | DateTime |

## Journals

**Path** `mag/Journals.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | JournalId| long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | NormalizedName | string |
4 | DisplayName | string |
5 | Issn | string |
6 | Publisher | string |
7 | Webpage | string |
8 | PaperCount | long |
9 | PaperFamilyCount | long | See [FAQ](resources-faq.md#papercount-vs-paperfamilycount)
10 | CitationCount | long |
11 | CreatedDate | DateTime |

## Paper Abstracts Inverted Index

**Path** `nlp/PaperAbstractsInvertedIndex.txt.{*}`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
2 | IndexedAbstract | string | See [FAQ](resources-faq.md#what-format-are-paper-abstracts-published-in) for format

> [!NOTE]
> Paper Abstracts Inverted Index is split to multiple files. Use `nlp/PaperAbstractsInvertedIndex.txt.{*}` as the path for the combined file.

## Paper Author Affiliations

**Path** `mag/PaperAuthorAffiliations.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers.PaperId
2 | AuthorId | long | FOREIGN KEY REFERENCES Authors.AuthorId
3 | AffiliationId | long? | FOREIGN KEY REFERENCES Affiliations.AffiliationId
4 | AuthorSequenceNumber | uint | 1-based author sequence number. 1: the 1st author listed on paper, 2: the 2nd author listed on paper, etc.
5 | OriginalAuthor | string |
6 | OriginalAffiliation | string |

> [!NOTE]
> It is possible to have multiple rows with same (PaperId, AuthorId, AffiliationId) when an author is associated with multiple affiliations.

## Paper Citation Contexts

**Path** `nlp/PaperCitationContexts.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers.PaperId
2 | PaperReferenceId | long | FOREIGN KEY REFERENCES Papers.PaperId
3 | CitationContext | string |

## Paper Extended Attributes

**Path** `mag/PaperExtendedAttributes.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers.PaperId
2 | AttributeType | int | 1: PatentId <br> 2: PubMedId <br> 3: PmcId <br> 4: Alternative Title
3 | AttributeValue | string |

## Paper Fields of Study

**Path** `advanced/PaperFieldsOfStudy.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
2 | FieldOfStudyId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId
3 | Score | float | Confidence range between 0 and 1. Bigger number representing higher confidence.

## Paper MeSH

**Path** `advanced/PaperMeSH.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers.PaperId
2 | DescriptorUI | string | 
3 | DescriptorName | string | 
4 | QualifierUI | string | 
5 | QualifierName | string | 
6 | IsMajorTopic | boolean | 

Please see [Medical Subject Headings documentation](https://www.nlm.nih.gov/mesh/mbinfo.html) for descriptor and qualifier definitions.

## Paper Recommendations

**Path** `advanced/PaperRecommendations.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
2 | RecommendedPaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
3 | Score | float | Confidence range between 0 and 1. Bigger number representing higher confidence.

## Paper References

**Path** `mag/PaperReferences.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
2 | PaperReferenceId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId

## Paper Resources

**Path** `mag/PaperResources.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | FOREIGN KEY REFERENCES Papers.PaperId
2 | ResourceType | int | Bit flags. 1 = Project, 2 = Data, 4 = Code
3 | ResourceUrl | string |
4 | SourceUrl | string |
5 | RelationshipType | int | Bit flags. 1 = Own, 2 = Cite

## Paper Urls

**Path** `mag/PaperUrls.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY <br> FOREIGN KEY REFERENCES Papers.PaperId
2 | SourceType | int? | 1 = Html, 2 = Text, 3 = Pdf, 4 = Doc, 5 = Ppt, 6 = Xls, 8 = Rtf, 12 = Xml, 13 = Rss, 20 = Swf, 27 = Ics, 31 = Pub, 33 = Ods, 34 = Odp, 35 = Odt, 36 = Zip, 40 = Mp3, 0/999/NULL = unknown
3 | SourceUrl | string | PRIMARY KEY
4 | LanguageCode | string |

## Papers

**Path** `mag/Papers.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | PaperId | long | PRIMARY KEY
2 | Rank | uint | See [FAQ](resources-faq.md#what-is-the-rank-value-on-entities)
3 | Doi | string | Doi values are upper-cased per [DOI standard](https://www.doi.org/doi_handbook/2_Numbering.html#2.4)
4 | DocType | string | Book, BookChapter, Conference, Dataset, Journal, Patent, Repository, Thesis, NULL : unknown
5 | PaperTitle | string |
6 | OriginalTitle | string |
7 | BookTitle | string |
8 | Year | int? |
9 | Date | DateTime? |
10 | OnlineDate | DateTime? |
11 | Publisher | string |
12 | JournalId | long? | FOREIGN KEY REFERENCES Journals.JournalId
13 | ConferenceSeriesId | long? | FOREIGN KEY REFERENCES ConferenceSeries.ConferenceSeriesId
14 | ConferenceInstanceId | long? | FOREIGN KEY REFERENCES ConferenceInstances.ConferenceInstanceId
15 | Volume | string |
16 | Issue | string |
17 | FirstPage | string |
18 | LastPage | string |
19 | ReferenceCount | long |
20 | CitationCount | long |
21 | EstimatedCitation | long |
22 | OriginalVenue | string |
23 | FamilyId | long? | See [FAQ](resources-faq.md#what-is-familyid-in-papers)
24 | FamilyRank | uint? | See [FAQ](resources-faq.md#rank-vs-familyrank-in-papers)
25 | DocSubTypes | string | "Retracted Publication", "Retraction Notice"
26 | CreatedDate | DateTime |

## Related Field of Study

**Path** `advanced/RelatedFieldOfStudy.txt`

**Schema**

Column # | Name | Type | Note
--- | --- | --- | ---
1 | FieldOfStudyId1 | long | FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId
2 | Type1 | string | general, disease, disease_cause, medical_treatment, symptom
3 | FieldOfStudyId2 | long | FOREIGN KEY REFERENCES FieldsOfStudy.FieldOfStudyId
4 | Type2 | string | general, disease, disease_cause, medical_treatment, symptom
5 | Rank | float | Confidence. Bigger number representing higher confidence.
