---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Journal entity schema

## Journal

Name | Type | Operations | Description
--- | --- | --- | ---
JournalName | string | equals, startsWith |
DisplayJournalName | blob | |
EntityType | string | equals |
Id | int64 | equals |
Issn | string | equals, startsWith |
PaperCount | int32 | equals, isBetween |
ReferenceCount | int32 | equals, isBetween |
RelatedEntities | [RelatedEntity](#relatedentity)[] | composite |
Webpage | string | equals, startsWith |

## RelatedEntity

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int62 | equals |
Name | string | equals, startsWith |
Relationship | int32 | equals |
Score | double | isBetween |
Type | string | equals |

## See also
