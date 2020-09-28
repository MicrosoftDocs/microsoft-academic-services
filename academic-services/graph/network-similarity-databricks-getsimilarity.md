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

## float1 getSimilarity(e1, e2)

Returns the similarity score between two entities.


**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
e1 | long | Id of the first entity | 1290206253
e2 | long | Id of the second entity | 201448701

**Return Value**

Data Type | Description | Example
--- | --- | ---
float | Similarity score between two entities | 0.7666980387511901

> [!NOTE]
>
> Score is between [-1, 1], with bigger number representing higher similarity.
>
> If either of the entity IDs are not available, the retrun value will be zero.

**Example**

   ```Python
   score = ns.getSimilarity(1290206253, 201448701)
   print(score)
   ```

**Output**

    > 0.7666980387511901
