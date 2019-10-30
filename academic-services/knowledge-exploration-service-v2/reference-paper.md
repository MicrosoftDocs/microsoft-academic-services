---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Paper entity schema

## Paper

Name | Type | Operations | Description
--- | --- | --- | ---
Authors | [PaperAuthor](#paperauthor)[] | composite |
BookTitle | string | equals |
CitationContexts | [PaperCitationContext](#papercitationcontext)[] | composite |
CitationCount | int32 | equals, isBetween |
ConferenceInstanceId | int64 | equals |
ConferenceInstanceName | string | equals, startsWith |
ConferenceSeriesId | int64 | equals |
ConferenceSeriesName | string | equals, startsWith |
Date | date | equals, isBetween |
Doi | string | equals, startsWith |
EntityType | string | equals |
EstimatedCitation | int32 | equals, isBetween |
ExtendedAttributes | [PaperExtendedAttribute](#paperextendedattribute)[] | composite |
FamilyId | int64 | equals |
FieldsOfStudy | [PaperFieldOfStudy](#paperfieldofstudy)[] | composite |
FirstPage | string | equals |
Id | int64 | equals |
InvertedAbstract | blob | |
Issue | string | equals |
LastPage | string | equals |
JournalId | int64 | equals |
JournalName | string | equals, startsWith |
OriginalTitle | blob | |
OriginalVenue | blob | |
PaperType | string | equals |
Publisher | date | equals |
Recommendations | [PaperRecommendation](#paperrecommendation)[] | composite |
References | int64[] | equals |
ReferenceCount | int32 | equals, isBetween |
Resources | [PaperResource](#paperresource)[] | composite |
Title | string | equals, startsWith |
TitleWords | string[] | equals |
Urls | [PaperUrl](#paperurl)[] | composite |
Volume | string | equals |
Year | int32 | equals, isBetween |

## PaperAuthor

Name | Type | Operations | Description
--- | --- | --- | ---
AffiliationId | int64 | equals |
AffiliationName | string | equals, startsWith |
Id | int64 | equals |
Name | string | equals, startsWith |
Sequence | int32 | equals |

## PaperCitationContext

Name | Type | Operations | Description
--- | --- | --- | ---
CitationContext | blob | |
PaperReferenceId | int64 | equals |

## PaperExtendedAttribute

Name | Type | Operations | Description
--- | --- | --- | ---
Type | string | equals |
Value | string | equals |

## PaperFieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int64 | equals |
Name | string | equals, startsWith |
Score | double | isBetween |

## PaperRecommendation

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int64 | equals |
Score | double | isBetween |

## PaperResource

Name | Type | Operations | Description
--- | --- | --- | ---
Relationship | int32 | equals |
SourceUrl | string | equals, startsWith |
Type | int32 | equals |
Url | string | equals, startsWith |

## PaperUrl

Name | Type | Operations | Description
--- | --- | --- | ---
LanguageCode | string | equals |
Type | int32 | equals |
Url | string | equals, startsWith |

## See also
