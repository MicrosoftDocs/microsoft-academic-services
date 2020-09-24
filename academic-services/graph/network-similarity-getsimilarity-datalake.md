---
title: NetworkSimilarity.GetSimilarity Function
description: NetworkSimilarity.GetSimilarity Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity.GetSimilarity Method

Namespace: AcademicGraph.NetworkSimilarity

### Compute similarity score between two entities.

## GetSimilarity(string, string, long, long)

Returns a similarity score between two entities. Score returned is between [-1, 1], with bigger number representing higher similarity.

**Parameters**

Name | Data Type | Description | Example
--- | --- | ---
BaseDir | string | uriPrefix of the Azure Storage container | "wasb://<blobContainer>@<blobAccount>/"
ResourcePath | string | Network similarity resouce path. Available resources are documented in [Network Similarity Package](network-similarity#contents) | "ns/AffiliationMetapath.txt"
entityId1 | long | ID of the first entity | 1290206253
entityId2 | long | ID of the second entity | 201448701

**Examples**

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetSimilarity(@uriPrefix, @resourcePath, @entityId1, @entityId2);
   ```

**Output**

    > 1290206253	201448701	af	0.766698062
