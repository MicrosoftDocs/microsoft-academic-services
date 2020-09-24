---
title: NetworkSimilarity.getSimilarity Function
description: NetworkSimilarity.getSimilarity Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity.getSimilarity Function

### Compute similarity score between two entities.

## getSimilarity(EntityId1, EntityId2)

Returns the similarity score between two entities.
Score returned is between [-1, 1], with bigger number representing higher similarity.
If either of the entity IDs are not in the resource file, the retrun value will be zero.

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
EntityId1 | long | Id of the first entity | 1290206253
EntityId2 | long | Id of the second entity | 201448701

**Example**

   ```Python
   score = ns.getSimilarity(1290206253, 201448701)
   print(score)
   ```

**Output**

    > 0.7666980387511901
