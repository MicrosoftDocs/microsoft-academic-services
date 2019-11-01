---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Affiliation entity schema

## affiliation

Name | Type | Operations | Description
--- | --- | --- | ---
affiliationName | string | equals, startsWith |
displayAffiliationName | blob | |
entityType | string | equals |
gridId | string | equals |
id | int64 | equals |
latitude | double | equals, isBetween |
longitude | double | equals, isBetween |
officialPage | string | equals |
paperCount | int32 | equals, isBetween |
referenceCount | int32 | equals, isBetween |
relatedEntities | [relatedEntities](#relatedEntities)[] | composite |
wikiPage | string | equals |

## relatedEntities

Name | Type | Operations | Description
--- | --- | --- | ---
id | int62 | equals |
name | string | equals, startsWith |
relationship | int32 | equals |
score | double | isBetween |
type | string | equals |