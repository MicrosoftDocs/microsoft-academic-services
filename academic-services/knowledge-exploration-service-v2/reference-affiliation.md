---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Affiliation entity schema

## Affiliation

Name | Type | Operations | Description
--- | --- | --- | ---
AffiliationName | string | equals, startsWith |
DisplayAffiliationName | blob | |
EntityType | string | equals |
GridId | string | equals |
Id | int64 | equals |
Latitude | double | equals, isBetween |
Longitude | double | equals, isBetween |
OfficialPage | string | equals |
PaperCount | int32 | equals, isBetween |
ReferenceCount | int32 | equals, isBetween |
RelatedEntities | [RelatedEntity](#relatedentity)[] | composite |
WikiPage | string | equals |

## RelatedEntity

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int62 | equals |
Name | string | equals, startsWith |
Relationship | int32 | equals |
Score | double | isBetween |
Type | string | equals |

## See also
