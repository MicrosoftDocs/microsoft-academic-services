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
children | [fieldOfStudyChild](#fieldofstudychild)[] | composite |
fieldOfStudyExtendedAttributes | [fieldOfStudyExtendedAttribute](#fieldofstudyextendedattribute)[] | composite |
id | int64 | equals |
level | int32 | equals, isBetween |
mainType | string | equals |
paperCount | int32 | equals, isBetween |
referenceCount | int32 | equals, isBetween |
relatedFieldsOfStudy | [relatedFieldOfStudy](#relatedfieldofstudy)[] | composite |

## fieldOfStudyChild

Name | Type | Operations | Description
--- | --- | --- | ---
id | int64 | equals |
name | string | equals, startsWith |

## fieldOfStudyExtendedAttribute

Name | Type | Operations | Description
--- | --- | --- | ---
type | int64 | equals |
value | string | equals |

## relatedFieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
id | int62 | equals |
name | string | equals, startsWith |
rank | double | isBetween |
relationship | string | equals |
type | string | equals |

## See also
