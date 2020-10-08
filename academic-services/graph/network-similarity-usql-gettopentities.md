---
title: NetworkSimilarity.GetTopEntities Function
description: NetworkSimilarity.GetTopEntities Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity.GetTopEntities Function

Namespace: AcademicGraph.NetworkSimilarity

### Returns entities with top similarity scores related to an entity.

## GetTopEntities(BaseDir, EntityType, Sense, EntityId, MaxCount, MinScore)

Given an EntityId and the EntityType, returns entities with top similarity scores based on a particular sense.

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
BaseDir | string | UriPrefix to the Azure Storage container | "wasb://mag-2020-01-01@myblobaccount/"
EntityType | string | Entity type. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "affiliation"
Sense | string | Similarity sense. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | "metapath"
EntityId | long | Id of the entity | 1290206253
MaxCount | int | Maximum number of results | 10
MinScore | float | Minimum score | 0

**Output Schema**

Column Name | Data Type | Description | Example
--- | --- | --- | ---
EntityId | long | Same value as input EntityId | 1290206253
SimilarEntityId | long | Id of the related entity | 1291425158
SimilarEntityType | string | Entity type. Possible types are <br> "af": Affiliation <br> "au": Author <br> "c": Conference <br> "f": Field of study <br> "j": Journal | "af"
Score | float | Similarity score between input entity and the related entity. <br> Score is between [-1, 1], with larger number representing higher similarity. <br> If the EntityId is not available, the return stream will be empty. | 0.971670866

**Example**

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetTopEntities("wasb://mag-2020-01-01@myblobaccount/", "affiliation", "metapath", 1290206253, 10, (float)0);
   ```

**Output**

   ```
   EntityId   | SimilarEntityId | SimilarEntityType | Score
   -----------+-----------------+-------------------+------------
   1290206253 |      1291425158 | af                | 0.971670866
   1290206253 |      2252078561 | af                | 0.961334944
   1290206253 |        28200790 | af                | 0.936774
   1290206253 |      1297971548 | af                | 0.929326236
   1290206253 |      1334257032 | af                | 0.9288712
   1290206253 |       184760556 | af                | 0.927445233
   1290206253 |        74973139 | af                | 0.9256075
   1290206253 |      1306409833 | af                | 0.9209746
   1290206253 |      2250653659 | af                | 0.9205189
   1290206253 |       184597095 | af                | 0.9195346
   ```
