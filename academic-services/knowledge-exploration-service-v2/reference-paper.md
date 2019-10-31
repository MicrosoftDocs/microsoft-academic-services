---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Paper entity schema

## paper

Name | Type | Operations | Description
--- | --- | --- | ---
authors | [paperAuthor](#paperauthor)[] | composite |
bookTitle | string | equals |
citationContexts | [paperCitationContext](#papercitationcontext)[] | composite |
citationCount | int32 | equals, isBetween |
conferenceInstanceId | int64 | equals |
conferenceInstanceName | string | equals, startsWith |
conferenceSeriesId | int64 | equals |
conferenceSeriesName | string | equals, startsWith |
date | date | equals, isBetween |
doi | string | equals, startsWith |
entityType | string | equals |
estimatedCitation | int32 | equals, isBetween |
extendedAttributes | [paperExtendedAttribute](#paperextendedattribute)[] | composite |
familyId | int64 | equals |
fieldsOfStudy | [paperFieldOfStudy](#paperfieldofstudy)[] | composite |
firstPage | string | equals |
id | int64 | equals |
invertedAbstract | blob | |
issue | string | equals |
lastPage | string | equals |
journalId | int64 | equals |
journalName | string | equals, startsWith |
originalTitle | blob | |
originalVenue | blob | |
paperType | string | equals |
publisher | date | equals |
recommendations | [paperRecommendation](#paperrecommendation)[] | composite |
references | int64[] | equals |
referenceCount | int32 | equals, isBetween |
resources | [paperResource](#paperresource)[] | composite |
title | string | equals, startsWith |
titleWords | string[] | equals |
urls | [paperUrl](#paperurl)[] | composite |
volume | string | equals |
year | int32 | equals, isBetween |

## paperAuthor

Name | Type | Operations | Description
--- | --- | --- | ---
affiliationId | int64 | equals |
affiliationName | string | equals, startsWith |
id | int64 | equals |
name | string | equals, startsWith |
sequence | int32 | equals |

## paperCitationContext

Name | Type | Operations | Description
--- | --- | --- | ---
citationContext | blob | |
paperReferenceId | int64 | equals |

## paperExtendedAttribute

Name | Type | Operations | Description
--- | --- | --- | ---
type | string | equals |
value | string | equals |

## paperFieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
id | int64 | equals |
name | string | equals, startsWith |
score | double | isBetween |

## paperRecommendation

Name | Type | Operations | Description
--- | --- | --- | ---
id | int64 | equals |
score | double | isBetween |

## paperResource

Name | Type | Operations | Description
--- | --- | --- | ---
relationship | int32 | equals |
sourceUrl | string | equals, startsWith |
type | int32 | equals |
url | string | equals, startsWith |

## paperUrl

Name | Type | Operations | Description
--- | --- | --- | ---
languageCode | string | equals |
type | int32 | equals |
url | string | equals, startsWith |