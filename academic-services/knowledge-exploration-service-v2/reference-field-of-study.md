---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Field of study entity schema

## FieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
FieldOfStudyName | string | equals, startsWith |
DisplayFieldOfStudyName | blob | |
EntityType | string | equals |
FieldOfStudyChildren | [FieldOfStudyChild](#fieldofstudychild)[] | composite |
FieldOfStudyExtendedAttributes | [FieldOfStudyExtendedAttribute](#fieldofstudyextendedattribute)[] | composite |
Id | int64 | equals |
Level | int32 | equals, isBetween |
MainType | string | equals |
PaperCount | int32 | equals, isBetween |
ReferenceCount | int32 | equals, isBetween |
RelatedFieldsOfStudy | [RelatedFieldOfStudy](#relatedfieldofstudy)[] | composite |

## FieldOfStudyChild

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int64 | equals |
Name | string | equals, startsWith |

## FieldOfStudyExtendedAttribute

Name | Type | Operations | Description
--- | --- | --- | ---
AttributeType | int64 | equals |
AttributeValue | string | equals |

## RelatedFieldOfStudy

Name | Type | Operations | Description
--- | --- | --- | ---
Id | int62 | equals |
Name | string | equals, startsWith |
Rank | double | isBetween |
Relationship | string | equals |
Type | string | equals |

## See also
