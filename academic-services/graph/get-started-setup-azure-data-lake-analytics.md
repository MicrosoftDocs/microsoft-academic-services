---
title: Microsoft Academic Graph using Data Lake Analytics
description: Set up Azure Data Lake Analytics for Microsoft Academic Graph
ms.topic: get-started-article
ms.date: 9/23/2019
---
# Set up Azure Data Lake Analytics for Microsoft Academic Graph

You could set up an Azure Data Lake Analytics to run U-SQL scripts on Microsoft Academic Graph. Here are the step-by-step instructions.

## Prerequisites

Complete these tasks before you begin this tutorial:

* Set up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

## Gather the information that you need

Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).


## Create Azure Data Lake Analytics account

1. Home > Create a resource > Analytics > Data Lake Analytics

    ![Create new Azure Data Lake Analytics account](media/create-analytics-account-select.png "Create new Azure Data Lake Analytics account")

1. Create new Data Lake Analytics and Data Lake Storage Gen1 accounts, following the flow indicated in figure below:

    ![Enter details for new Azure Data Lake Analytics account](media/create-analytics-account-details.png "Enter details for new Azure Data Lake Analytics account")

    > [!IMPORTANT]
    > Both accounts require a globally unique name

1. Make sure that you have these items of information:

   :heavy_check_mark: The name of your Azure Data Lake Analytics (ADLA) account, e.g. **mymagadla** in the above example.

   :heavy_check_mark: The name of your Azure Data Lake Storage (ADLS) account, e.g. **mymagadls** in the above example.

## Configure Azure Data Lake Analytics to use Microsoft Academic Graph

1. Navigate to the new Azure Data Lake Analytics account created in the first section and add a new data source:

   ![Add new data source to analytics account](media/configure-analytics-account-datasource.png "Add new data source to analytics account")

1. On the "add data source" dialog, select storage type "azure storage", selection method "select account" and the Azure Storage (AS) account you created for MAG provisioning:

   ![Select storage account created earlier](media/configure-analytics-account-select.png "Select storage account created earlier")

## Next steps

Advance to the next step to learn about analytics and visualization using Azure Data Lake Analytics.

> [!div class="nextstepaction"]
>[Compute author h-index tutorial (U-SQL)](tutorial-usql-hindex.md)

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
* [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/)
