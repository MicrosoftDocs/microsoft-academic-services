---
title: NetworkSimilarity.GetSimilarity Function
description: NetworkSimilarity.GetSimilarity Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity.GetSimilarity Function

Namespace: AcademicGraph.NetworkSimilarity

### Compute similarity score between two entities.

## GetSimilarity(BaseDir, EntityType, Sense, EntityId1, EntityId2)

Returns a stream with a single row containing the similarity score between two entities using a network similarity resource.
Score returned is between [-1, 1], with bigger number representing higher similarity.
If either of the entity IDs are not in the resource file, the retrun stream will be empty.

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
BaseDir | string | UriPrefix to the Azure Storage container | "wasb://mag-2020-01-01@myblobaccount/"
EntityType | string | Entity Type. Available entity types are documented in [Network Similarity Package](network-similarity#available-senses) | "affiliation"
Sense | string | Similarity sense. Available senses are documented in [Network Similarity Package](network-similarity#available-senses) | "metapath"
EntityId1 | long | Id of the first entity | 1290206253
EntityId2 | long | Id of the second entity | 201448701

**Example**

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetSimilarity("wasb://mag-2020-01-01@myblobaccount/", "affiliation", "metapath", 1290206253, 201448701);
   ```

**Output**

   ```
   EntityId   | SimilarEntityId | SimilarEntityType | Score
   -----------+-----------------+-------------------+------------
   1290206253 | 201448701       | af                | 0.766698062
   ```
