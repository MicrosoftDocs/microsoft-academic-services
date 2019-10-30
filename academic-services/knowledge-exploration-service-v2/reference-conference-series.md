---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Conference series entity schema

## conferenceSeries

Name | Type | Operations | Description
--- | --- | --- | ---
conferenceSeriesName | string | equals, startsWith |
displayConferenceSeriesName | blob | |
entityType | string | equals |
id | int64 | equals |
paperCount | int32 | equals, isBetween |
referenceCount | int32 | equals, isBetween |
relatedEntities | [relatedEntity](#relatedentity)[] | composite |

## relatedEntity

Name | Type | Operations | Description
--- | --- | --- | ---
id | int62 | equals |
name | string | equals, startsWith |
relationship | int32 | equals |
score | double | isBetween |
type | string | equals |

## See also
