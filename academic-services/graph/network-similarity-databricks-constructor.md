---
title: NetworkSimilarity Constructor
description: NetworkSimilarity Constructor
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# NetworkSimilarity(string) Constructor (PySpark)

### Initializes a new instance of the NetworkSimilarity class.

  ```Python
  class NetworkSimilarity(account, container, entitytype, sense, sas='', key='');
  ```

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
account | string | Azure Storage (AS) account | 'myblobaccount'
container | string | Container name in Azure Storage (AS) account | 'mag-2020-01-01'
entitytype | string | Entity type. See available entity types and senses in [Network Similarity Package](network-similarity#available-senses) | 'affiliation'
sense | string | Similarity sense. See available entity types and senses in [Network Similarity Package](network-similarity#available-senses) | 'metapath'
sas | string | Complete 'Blob service SAS URL' of the shared access signature (sas) for the container | 'myshareaccesssignature'
key | string | Access key for the container, if sas is specified, key is ignored | 'myaccountkey'

**Example**

   ```Python
   ns = NetworkSimilarity(account='myblobaccount', container='mag-2020-01-01', entitytype='affiliation', sense='metapath', sas='myshareaccesssignature')
   ```

**Output**

None.
