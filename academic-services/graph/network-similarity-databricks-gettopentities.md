---
title: NetworkSimilarity.getTopEntities Function
description: NetworkSimilarity.getTopEntities Function
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity.getTopEntities Function

## getTopEntities(e, targetType, maxCount, minScore)

Returns a dataframe with entities of top similarity scores to an entity.

**Parameters**

Name | Data Type | Description | Default | Example
--- | --- | --- | --- | ---
e | long | Id of the entity | | 1290206253
targetType | string | target entity type. If empty, include all entity types in the resource file  | '' | 'af'
maxCount | int | Maximum number of result | 20 | 10
minScore | float | Minimum score | 0.0 | 0.0

**Return Dataframe**

Column Name | Data Type | Description | Example
--- | --- | --- | ---
EntityId | long | Id of the related entity | 1291425158
EntityType | string | Entity type. Possible types are <br> "af": Affiliation <br> "au": Author <br> "c": Conference <br> "j": Journal <br> "fos": Field of study | "af"
Score | float | Similarity score between input entity and the related entity. | 0.971670866

> [!NOTE]
>
> Score is between [-1, 1], with bigger number representing higher similarity.
>
> If the entity ID is not available, the retrun dataframe will be empty.

**Example**

   ```python
   topEntities = ns.getTopEntities(1290206253)
   display(topEntities)
   ```

**Output**
- Sample output.

    ![GetTopEntities output](media/network-similarity/databricks-get-top-entities.png "GetTopEntities output")
