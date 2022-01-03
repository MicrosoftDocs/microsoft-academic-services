---
title: Field of study entity attributes
description: Learn the attributes you can use with field of study entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 2020-02-24
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Field Of Study Entity

> [!NOTE]
> Following attributes are specific to field of study entity. (Ty = '6')

Name | Description | Type | Operations
--- | --- | --- | ---
CC | Field of study total citation count | Int32 | None  
DFN | Field of study display name | String | None
ECC | Field of total estimated citation count | Int32 | None
FL | Level in fields of study hierarchy | Int32 | Equals, IsBetween
FN | Field of study normalized name | String | Equals
FC.FId | Child field of study ID | Int64 | Equals
FC.FN | Child field of study name | String | Equals
FP.FId | Parent field of study ID | Int64 | Equals
FP.FN | Parent field of study name | String | Equals
Id | Entity ID | Int64 | Equals
PC | Field of study total publication count | Int32 | None
