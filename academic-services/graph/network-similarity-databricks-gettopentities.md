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

Returns a dataframe containing entities with the highest similarity scores in relation to the passed in entity id.

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
EntityType | string | Entity type. Possible types are <br> "af": Affiliation <br> "au": Author <br> "c": Conference <br> "f": Field of study <br> "j": Journal | "af"
Score | float | Similarity score between input entity and the related entity. <br> Score is between [-1, 1], with larger number representing higher similarity. <br> If the entity ID is not available, the return dataframe will be empty. | 0.971670866

**Example**

   ```python
   topEntities = ns.getTopEntities(1290206253)
   display(topEntities)
   ```

**Output**
- Sample output.

    ![GetTopEntities output](media/network-similarity/databricks-get-top-entities.png "GetTopEntities output")
