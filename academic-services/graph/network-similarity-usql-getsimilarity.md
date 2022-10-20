---
title: NetworkSimilarity.GetSimilarity Function
description: NetworkSimilarity.GetSimilarity Function
services: microsoft-academic-services
ms.topic: reference
ms.service: microsoft-academic-services
ms.date: 4/23/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# NetworkSimilarity.GetSimilarity Function

Namespace: AcademicGraph.NetworkSimilarity

Returns a stream with a single row containing the similarity score between two entities using a network similarity resource.
Score returned is between [-1, 1], with larger number representing higher similarity.
If either of the entity IDs are not in the resource file, the return stream will be empty.

## GetSimilarity(string, string, string, long, long)

  ```U-SQL
  GetSimilarity(string BaseDir, string EntityType, string Sense, long EntityId1, long EntityId2)
  ```

### Parameters

| Name | Data Type | Description | Example |
| --- | --- | --- | --- |
| BaseDir | string | UriPrefix to the Azure Storage container | "wasb://mag-2020-01-01@myblobaccount/" |
| EntityType | string | Entity Type. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "affiliation" |
| Sense | string | Similarity sense. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "metapath" |
| EntityId1 | long | Id of the first entity | 1290206253 |
| EntityId2 | long | Id of the second entity | 201448701 |

### Output Schema

| Name | Data Type | Description | Example |
| --- | --- | --- | --- |
| EntityId | long | Same value as EntityId1 | 1290206253 |
| SimilarEntityId | long | Same value as EntityId2 | 201448701 |
| Score | float | Similarity score between EntityId1 and EntityId2. <br> Score is between [-1, 1], with larger number representing higher similarity. <br> If either of the entity IDs are not available, the return stream will be empty. | 0.766698062 |

### Example

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetSimilarity("wasb://mycontainer@myblobaccount/mag/2020-01-01/", "affiliation", "metapath", 1290206253, 201448701);
   ```

### Output

   ```
   EntityId   | SimilarEntityId | Score
   -----------+-----------------+------------
   1290206253 | 201448701       | 0.766698062
   ```
