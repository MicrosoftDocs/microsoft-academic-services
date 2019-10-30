---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Conference series entity schema

## ConferenceSeries

Name | Type | Operations | Description
--- | --- | --- | ---
ConferenceSeriesName | string | equals, startsWith |
DisplayConferenceSeriesName | blob | |
EntityType | string | equals |
Id | int64 | equals |
PaperCount | int32 | equals, isBetween |
ReferenceCount | int32 | equals, isBetween |
RelatedEntities | [RelatedEntity](#relatedentity)[] | composite |

## RelatedEntity

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int62 | equals |
Name | string | equals, startsWith |
Relationship | int32 | equals |
Score | double | isBetween |
Type | string | equals |

## See also
