---
title: Receive Microsoft Academic Knowledge Exploration Service
description: Step-by-step instructions for receiving Microsoft Academic Knowledge Exploration Service using Azure Data Share
ms.topic: get-started-article
ms.date: 3/23/2021
---

# Receive MAKES releases using Azure Data Share

[!INCLUDE [ma-subscription-receive-data](../includes/ma-subscription-receive-data.md)]

## MAKES releases

MAKES release are deployed approximately once a week to the Azure storage account that were used to signed up for the distribution preview.

Each release has a unique name reflecting the date it was created, and is placed in the following location inside the storage account:

Microsoft Academic Data storage container
- makes
  - YYYY-MM-DD (release date)
    - index
      - makes-YYYY-MM-DD-prod-index#.kes
    - grammar
      - makes-default-grammar
    - tools
      - indexer.zip
      - preprocessor.zip
      - jobManager.zip
      - kesm.zip
    - webhost
      - makes-service-host.zip
    - License.docx

## Next steps

Deploy your first MAKES instance 
> [!div class="nextstepaction"]
>[Deploy a MAKES instance to Azure](get-started-create-api-instances.md)


## Resources

* [Azure Data Share](https://azure.microsoft.com/services/data-share/)

* [Tutorial: Accept and receive data using Azure Data Share](https://docs.microsoft.com/azure/data-share/subscribe-to-data-share)
