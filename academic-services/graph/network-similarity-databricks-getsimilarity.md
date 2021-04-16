---
title: NetworkSimilarity.getSimilarity Function
description: NetworkSimilarity.getSimilarity Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 4/16/2021
---
# NetworkSimilarity.getSimilarity Function

## Compute the similarity score between two entities.

## float getSimilarity(entityId1, entityId2)

Returns the similarity score between two entities.

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
