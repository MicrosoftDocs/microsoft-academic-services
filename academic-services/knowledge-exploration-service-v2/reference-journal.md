---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Journal entity schema

## journal

Name | Type | Operations | Description
--- | --- | --- | ---
displayJournalName | blob | |
entityType | string | equals |
id | int64 | equals |
issn | string | equals, startsWith |
journalName | string | equals, startsWith |
paperCount | int32 | equals, isBetween |
referenceCount | int32 | equals, isBetween |
relatedEntities | [relatedEntity](#relatedentity)[] | composite |
webpage | string | equals, startsWith |

## relatedEntity

Name | Type | Operations | Description
--- | --- | --- | ---
id | int62 | equals |
name | string | equals, startsWith |
relationship | int32 | equals |
score | double | isBetween |
type | string | equals |

## See also
