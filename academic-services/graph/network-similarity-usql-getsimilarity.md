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
EntityType | string | Entity Type. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "affiliation"
Sense | string | Similarity sense. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "metapath"
EntityId1 | long | Id of the first entity | 1290206253
EntityId2 | long | Id of the second entity | 201448701

**Output Schema**

Name | Data Type | Description | Example
--- | --- | --- | ---
EntityId | long | Same value as EntityId1 | 1290206253
SimilarEntityId | long | Same value as EntityId2 | 201448701
SimilarEntityType | string | Entity type. Possible types are <br> "af": Affiliation <br> "au": Author <br> "c": Conference <br> "f": Field of study <br> "j": Journal | "af"
Score | float | Similarity score between EntityId1 and EntityId2. <br> Score is between [-1, 1], with bigger number representing higher similarity. <br> If either of the entity IDs are not available, the retrun stream will be empty. | 0.766698062

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
