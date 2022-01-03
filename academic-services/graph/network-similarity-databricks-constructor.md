---
title: NetworkSimilarity Constructor
description: NetworkSimilarity Constructor
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 4/23/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# NetworkSimilarity Constructor (PySpark)

Initializes a new instance of the NetworkSimilarity class.

## NetworkSimilarity(MicrosoftAcademicGraph, string, string)

  ```Python
  class NetworkSimilarity(MicrosoftAcademicGraph mag, string entitytype, string sense);
  ```

### Parameters

| Name | Data Type | Description | Example |
| --- | --- | --- | --- |
| mag | MicrosoftAcademicGraph | An instance of MicrosoftAcademicGraph | See example below |
| entitytype | string | Entity type. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | 'affiliation' |
| sense | string | Similarity sense. See available entity types and senses in [Network Similarity Package](network-similarity.md#available-senses) | 'metapath' |

### Example

   ```Python
   MAG = MicrosoftAcademicGraph(account='myblobaccount', sas='myshareaccesssignature', container='mycontainer', version='mag/2020-01-01')
   NS = NetworkSimilarity(mag=MAG, entitytype='affiliation', sense='metapath')
   ```

### Output

None.
