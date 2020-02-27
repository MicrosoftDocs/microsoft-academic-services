---
title: Network Similarity Sample (U-SQL)
description: Network Similarity Sample (U-SQL)
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 2/25/2020
---
# Network Similarity Sample (U-SQL)

In this sample, you compute network similarity score and top related affiliations in Microsoft Academic Graph (MAG) using Azure Data Analytics (U-SQL).

## Prerequisites

Complete these tasks before beginning this tutorial:

* [Set up provisioning of Microsoft Academic Graph to an Azure blob storage account](get-started-setup-provisioning.md)
* [Set up Azure Data Lake Analytics for Microsoft Academic Graph](get-started-setup-azure-data-lake-analytics.md)

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of your Azure Data Lake Analytics (ADLA) service from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of your Azure Data Lake Storage (ADLS) from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

## Define functions to extract MAG data

In prerequisite [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md), you added the Azure Storage (AS) created for MAG provision as a data source for the Azure Data Lake Analytics service (ADLA). In this section, you submit an ADLA job to create functions extracting MAG data from Azure Storage (AS).

1. Download `samples/CreateFunctions.usql` to your local drive. <br> From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [mag-yyyy-mm-dd] > samples > CreateFunctions.usql > Download**.

   ![Download CreateFunctions.usql](media/samples-azure-data-lake-hindex/create-functions-download.png "Download CreateFunctions.usql")

1. Go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview > New job > Open file**. Select `CreateFunctions.usql` in your local drive.

   ![New job - Open CreateFunctions.usql](media/samples-azure-data-lake-hindex/create-functions-open.png "New job - Open CreateFunctions.usql")

1. Select **Submit**.

   ![Submit CreateFunctions job](media/samples-azure-data-lake-hindex/create-functions-submit.png "Submit CreateFunctions job")

1. The job should finish successfully.

   ![CreateFunctions job status](media/samples-azure-data-lake-hindex/create-functions-status.png "CreateFunctions job status")

## Define network similarity functions

In this section, you submit an ADLA job to define network similarity functions.

1. Download `ns/NetworkSimilarityFunction.usql` to your local drive. <br> From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [mag-yyyy-mm-dd] > ns > NetworkSimilarityFunction.usql > Download**.

1. Go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview > New job > Open file**. Select `NetworkSimilarityFunction.usql` in your local drive.

1. Select **Submit**.

1. The job should finish successfully.

## Run Sample script

1. Download `ns/NetworkSimilaritySample.usql` to your local drive. <br> From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [mag-yyyy-mm-dd] > ns > NetworkSimilaritySample.usql > Download**.

1. Go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview > New job > Open file**. Select `NetworkSimilaritySample.usql` in your local drive.

1. Replace `<AzureStorageAccount>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample.

   |Value  |Description  |
   |---------|---------|
   |**`<AzureStorageAccount>`** | The name of your Azure Storage (AS) account containing MAG dataset. |
   |**`<MagContainer>`** | The container name in Azure Storage (AS) account containing MAG dataset, usually in the form of **mag-yyyy-mm-dd**. |

1. Select **Submit**.

1. The job should finish successfully.

## Script description

### Getting similarity score between two entities

- Following script calls getSimilarity method to get similarity score between two entities

   ```U-SQL
   @score = AcademicGraph.NetworkSimilarity.GetSimilarity(@uriPrefix, @resourcePath, @entityId1, @entityId2);
   ```

- You will see output in `/Output/NetworkSimilarity/GetSimilarity.tsv` as follows

    > 1290206253	201448701	af	0.766698062

### Getting top related entities

- Following script calls getTopEntities method to get top related entities

   ```U-SQL
   @topEntities = AcademicGraph.NetworkSimilarity.GetTopEntities(@uriPrefix, @resourcePath, @entityId1, 20, (float)0);
   ```

- You will see output in `/Output/NetworkSimilarity/GetTopEntities.tsv` as follows

    ![GetTopEntities output](media/network-similarity/usql-get-top-entities.png "GetTopEntities output")

### Getting entity details

- Following script joins top entities with affiliation table to get entity details

   ```U-SQL
   @affiliations = Affiliations(@uriPrefix);

   @topEntityDetails =
       SELECT
           @topEntities.SimilarEntityId,
           @affiliations.DisplayName,
           @topEntities.Score
       FROM @topEntities
       INNER JOIN @affiliations
       ON @topEntities.SimilarEntityId == @affiliations.AffiliationId;
   ```

- You will see output in `/Output/NetworkSimilarity/TopEntityDetails.tsv` as follows

    ![Top entities detail](media/network-similarity/usql-top-entities-detail.png "Top entities detail")

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
* [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/)
* [U-SQL Language Reference](https://docs.microsoft.com/u-sql/)
