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

## GetTopEntities(string, string, long, int, float)

Returns a stream with entities of top similarity scores to an entity using a network similarity resource.
Score returned is between [-1, 1], with bigger number representing higher similarity.
If the entity ID is not in the resource file, the retrun stream will be empty.

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
BaseDir | string | UriPrefix to the Azure Storage container | "wasb://mag-2020-01-01@myblobaccount/"
ResourcePath | string | Network similarity resouce path. Available resources are documented in [Network Similarity Package](network-similarity#contents) | "ns/AffiliationMetapath.txt"
EntityId | long | Id of the entity | 1290206253
MaxCount | int | Maximum number of result | 10
MinScore | float | Minimum score | 0.0

**Example**

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetTopEntities("wasb://mag-2020-01-01@myblobaccount/", "ns/AffiliationMetapath.txt", 1290206253, 10, (float)0);
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
