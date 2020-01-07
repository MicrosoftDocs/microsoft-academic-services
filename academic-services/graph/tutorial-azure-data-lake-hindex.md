---
title: 'Tutorial: Compute author h-index using Azure Data Lake Analytics (U-SQL)'
description: Compute author h-index for Microsoft Academic Graph using Azure Data Lake Analytics (U-SQL)
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 7/5/2019
---
# Tutorial: Compute author h-index using Azure Data Lake Analytics (U-SQL)

In this tutorial, you compute h-index for all authors in Microsoft Academic Graph (MAG) using Azure Data Lake Analytics (U-SQL). You extract data from Azure Storage, compute h-index, and save the result in Azure Data Lake Storage.

## Prerequisites

Complete these tasks before you begin this tutorial:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).
* Setting up Azure Data Lake Analytics. See [Set up Azure Data Lake Analytics for Microsoft Academic Graph](get-started-setup-azure-data-lake-analytics.md).

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of your Azure Data Lake Analytics (ADLA) service from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of your Azure Data Lake Storage (ADLS) from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

## Define functions to extract MAG data

In prerequisite [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md), you added the Azure Storage  (AS) created for MAG provision as a data source for the Azure Data Lake Analytics service (ADLA). In this section, you submit an ADLA job to create functions extracting MAG data from Azure Storage (AS).

1. In the [Azure portal](https://portal.azure.com), go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview** > **New Job**.

   ![Azure Data Lake Analytics - New job](media/samples-azure-data-lake-hindex/new-job.png "Azure Data Lake Analytics - New job")

1. Copy code in samples/CreateFunctions.usql and paste into the code block.
   
1. Provide a **Job name** and select **Submit**.

   ![Submit CreateFunctions job](media/samples-azure-data-lake-hindex/create-functions-submit.png "Submit CreateFunctions job")

1. The job should finish successfully.

   ![CreateFunctions job status](media/samples-azure-data-lake-hindex/create-functions-status.png "CreateFunctions job status")

## Compute author h-index

In this section, you submit an ADLA job to compute author h-index and save output to Azure Data Lake Storage (ADLS).

1. In the [Azure portal](https://portal.azure.com), go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview** > **New Job**.

   ![Azure Data Lake Analytics - New job](media/samples-azure-data-lake-hindex/new-job.png "Azure Data Lake Analytics - New job")

1. Copy and paste the following code block in the script window.
   
   ```U-SQL
   DECLARE @dataVersion string = "<MagContainer>";
   DECLARE @blobAccount string = "<AzureStorageAccount>";
   DECLARE @uriPrefix   string = "wasb://" + @dataVersion + "@" + @blobAccount + "/";
   DECLARE @outAuthorHindex string = "/Output/AuthorHIndex.tsv";
   
   @Affiliations = Affiliations(@uriPrefix);
   @Authors = Authors(@uriPrefix);
   @Papers = Papers(@uriPrefix);
   @PaperAuthorAffiliations = PaperAuthorAffiliations(@uriPrefix);
   
   // Get Affiliations
   @Affiliations =
       SELECT
           (long?)AffiliationId AS AffiliationId, // Change datatype join with PaperAuthorAffiliations later
           DisplayName
       FROM @Affiliations;
   
   // Get Authors
   @Authors =
       SELECT
           AuthorId,
           DisplayName,
           LastKnownAffiliationId,
           PaperCount
       FROM @Authors;
   
   // Get (Author, Paper) pairs
   @AuthorPaper =
       SELECT DISTINCT
           AuthorId,
           PaperId
       FROM @PaperAuthorAffiliations;

   // Get (Paper, EstimatedCitation).
   // Treat papers with same FamilyId as a single paper and sum the EstimatedCitation
   @PaperCitation =
       SELECT
           (long)(FamilyId == null ? PaperId : FamilyId) AS PaperId,
           EstimatedCitation
       FROM @Papers
       WHERE EstimatedCitation > 0;

   @PaperCitation =
       SELECT
           PaperId,
           SUM(EstimatedCitation) AS EstimatedCitation
       FROM @PaperCitation
       GROUP BY PaperId;

   // Generate author, paper, citation view
   @AuthorPaperCitation =
       SELECT
           A.AuthorId,
           A.PaperId,
           P.EstimatedCitation
       FROM @AuthorPaper AS A
       INNER JOIN @PaperCitation AS P
           ON A.PaperId == P.PaperId;
   
   // Order author, paper by citation
   @AuthorPaperOrderByCitation =
       SELECT
           AuthorId,
           PaperId,
           EstimatedCitation,
           ROW_NUMBER() OVER(PARTITION BY AuthorId ORDER BY EstimatedCitation DESC) AS Rank
       FROM @AuthorPaperCitation;
   
   // Generate author hindex
   @AuthorHIndexTemp =
       SELECT
           AuthorId,
           SUM(EstimatedCitation) AS TotalEstimatedCitation,
           MAX(CASE WHEN EstimatedCitation >= Rank THEN Rank ELSE 0 END) AS HIndex
       FROM @AuthorPaperOrderByCitation 
       GROUP BY AuthorId;
   
   // Get author detail information
   @AuthorHIndex =
       SELECT
           I.AuthorId,
           A.DisplayName,
           F.DisplayName AS AffiliationDisplayName,
           A.PaperCount,
           I.TotalEstimatedCitation,
           I.HIndex
       FROM @AuthorHIndexTemp AS I
       INNER JOIN @Authors AS A
           ON A.AuthorId == I.AuthorId
       LEFT OUTER JOIN @Affiliations AS F
           ON A.LastKnownAffiliationId == F.AffiliationId;
   
   OUTPUT @AuthorHIndex
   TO @outAuthorHindex
   ORDER BY HIndex DESC, AuthorId
   FETCH 100 ROWS
   USING Outputters.Tsv(quoting : false);
   ```

1. In this code block, replace `<AzureStorageAccount>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample.

   |Value  |Description  |
   |---------|---------|
   |**`<AzureStorageAccount>`** | The name of your Azure Storage (AS) account containing MAG dataset. |
   |**`<MagContainer>`** | The container name in Azure Storage (AS) account containing MAG dataset, usually in the form of **mag-yyyy-mm-dd**. |

1. Provide a **Job name**, change **AUs** to 5, and select **Submit**.

   ![Submit AuthorHIndex job](media/samples-azure-data-lake-hindex/author-hindex-submit.png "Submit AuthorHIndex job")

1. The job should finish successfully in about 10 minutes.

   ![AuthorHIndex job status](media/samples-azure-data-lake-hindex/author-hindex-status.png "AuthorHIndex job status")

## View output data

The output of the ADLA job in previous section goes to "/Output/AuthorHIndex.tsv" in the Azure Data Lake Storage (ADLS). In this section, you use [Azure portal](https://portal.azure.com/) to view output content.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Data Lake Storage (ADLS) service that you created, and select **Data Explorer**.

   ![Data Explorer](media/samples-azure-data-lake-hindex/adls-data-explorer.png "Data Explorer")

1. Select **Output** > **AuthorHIndex.tsv**.

   ![AuthorHIndex.tsv](media/samples-azure-data-lake-hindex/adls-data-explorer-2.png "AuthorHIndex.tsv")

1. You see an output similar to the following snippet:

   ![AuthorHIndex.tsv preview](media/samples-azure-data-lake-hindex/adls-file-preview.png "AuthorHIndex.tsv preview")

## Next steps

If you're interested in Academic analytics and visualization, we have created U-SQL samples that use some of the same functions referenced in this tutorial.

> [!div class="nextstepaction"]
>[Analytics and visualization samples](samples-azure-data-lake-analytics.md)

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
* [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/)
* [U-SQL Language Reference](https://docs.microsoft.com/u-sql/)
* [H-index](https://en.wikipedia.org/wiki/H-index)
