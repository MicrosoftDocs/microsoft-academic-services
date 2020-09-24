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
  class NetworkSimilarity(account, container, resource, sas='', key='');
  ```

**Parameters**

Name | Data Type | Description | Example
--- | --- | --- | ---
account | string | Azure Storage (AS) account | 'myblobaccount'
container | string | Container name in Azure Storage (AS) account | 'mag-2020-01-01'
resource | string | Resource stream path | 'ns/AffiliationMetapath.txt'
sas | string | Complete 'Blob service SAS URL' of the shared access signature (sas) for the container | 'myshareaccesssignature'
key | string | Access key for the container, if sas is specified, key is ignored | 'myaccountkey'

**Example**

   ```Python
   ns = NetworkSimilarity(account='myblobaccount', container='mag-2020-01-01', resource='ns/AffiliationMetapath.txt', sas='myshareaccesssignature')
   ```

**Output**

None.
