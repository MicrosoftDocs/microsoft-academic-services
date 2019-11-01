---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Field of study entity schema

## fieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
fieldOfStudyName | string | equals, startsWith |
displayFieldOfStudyName | blob | |
entityType | string | equals |
children | [children](#children)[] | composite |
fieldOfStudyExtendedAttributes | [fieldOfStudyExtendedAttributes](#fieldOfStudyExtendedAttributes)[] | composite |
id | int64 | equals |
level | int32 | equals, isBetween |
mainType | string | equals |
paperCount | int32 | equals, isBetween |
referenceCount | int32 | equals, isBetween |
relatedFieldsOfStudy | [relatedFieldsOfStudy](#relatedfieldofstudy)[] | composite |

## children

Name | Type | Operations | Description
--- | --- | --- | ---
id | int64 | equals |
name | string | equals, startsWith |

## fieldOfStudyExtendedAttributes

Name | Type | Operations | Description
--- | --- | --- | ---
type | int64 | equals |
value | string | equals |

## relatedFieldsOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
id | int62 | equals |
name | string | equals, startsWith |
rank | double | isBetween |
relationship | string | equals |
type | string | equals |