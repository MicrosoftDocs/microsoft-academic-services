---
title: Author entity attributes
description: Learn the attributes you can use with author entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 2020-02-24
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Author Entity

> [!NOTE]
> Following attributes are specific to author entity. (Ty = '1')

Name | Description | Type | Operations
--- | --- | --- | ---
Id | Entity ID | Int64 | Equals
AuN | Author normalized name | String | Equals
CC | Author total citation count | Int32 | None 
DAuN | Author display name | String | None
ECC | Author total estimated citation count | Int32 | None
LKA.AfId | Entity ID of the last known affiliation found for the author | Int64 | None
LKA.AfN | Normalized name of the last known affiliation found for the author | String | None
PC | Author total publication count | Int32 | None
