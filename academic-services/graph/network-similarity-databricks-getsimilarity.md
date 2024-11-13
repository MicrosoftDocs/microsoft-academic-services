---
title: NetworkSimilarity.getSimilarity Function
description: NetworkSimilarity.getSimilarity Function
services: microsoft-academic-services
ms.topic: reference
ms.service: microsoft-academic-services
ms.date: 4/23/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# NetworkSimilarity.getSimilarity Function

Compute the similarity score between two entities.

## float getSimilarity(long, long)

  ```Python
  float getSimilarity(long entityId1, long entityId2)
  ```

### Parameters

| Name | Data Type | Description | Example |
| --- | --- | --- | --- |
| entityId1 | long | Id of the first entity | 1290206253 |
| entityId2 | long | Id of the second entity | 201448701 |

### Return Value

| Data Type | Description | Example |
| --- | --- | --- |
| float | Similarity score between two entities. <br> Score is between [-1, 1], with larger number representing higher similarity. <br> If either of the entity IDs are not available, the return value will be zero. | 0.7666980387511901 |

### Example

   ```Python
   score = ns.getSimilarity(1290206253, 201448701)
   print(score)
   ```

### Output

   ```
   0.7666980387511901
   ```
