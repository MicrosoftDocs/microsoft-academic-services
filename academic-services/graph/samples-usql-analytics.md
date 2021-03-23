---
title: Analytics samples for Microsoft Academic Graph
description: Perform analytics and visualization for Microsoft Academic Graph using Data Lake Analytics (U-SQL) and Power BI
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 3/23/2021
---
# Analytics and visualization samples for Microsoft Academic Graph

Illustrates how to perform analytics and visualization for Microsoft Academic Graph using Data Lake Analytics (U-SQL) and Power BI.

## Prerequisites

Complete these tasks before beginning this tutorial:

* [Set up provisioning of Microsoft Academic Graph to an Azure blob storage account](get-started-setup-provisioning.md)
* [Set up an Azure Data Lake Analytics for Microsoft Academic Graph](get-started-setup-azure-data-lake-analytics.md)
* [Microsoft Power BI Desktop client](https://powerbi.microsoft.com/en-us/desktop/)
* Visual Studio 2017 or Visual Studio 2015 with [Data Lake tools](https://www.microsoft.com/en-us/download/details.aspx?id=49504)

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name).

   :heavy_check_mark:  The name of your Azure Data Lake Analytics (ADLA) service from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of your Azure Data Lake Storage (ADLS) from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md#create-azure-data-lake-analytics-account).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

   :heavy_check_mark:  The path to a MAG dataset in the container.

## Define functions to extract MAG data

In prerequisite [Set up an Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md), you added the Azure Storage (AS) created for MAG provision as a data source for the Azure Data Lake Analytics service (ADLA). In this section, you submit an ADLA job to create functions extracting MAG data from Azure Storage (AS).

Follow instructions in [Define MAG functions](define-mag-function.md).

## Sample projects

* [Field of Study Top Authors](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/01.%20Field%20of%20Study%20Top%20Authors)
* [Field of Study Entity Counts](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/11.%20Field%20of%20Study%20Entity%20Counts)
* [Field of Study Top Entities](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/13.%20Field%20of%20Study%20Top%20Entities)
* [Conference Top Authors By Static Rank](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/02.%20Conference%20Top%20Authors%20By%20Static%20Rank)
* [Conference Paper Statistics](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/03.%20Conference%20Papers%20Basic%20Statistics)
* [Conference Top Papers](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/04.%20Conference%20Top%20Papers)
* [Conference Top Authors](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/05.%20Conference%20Top%20Authors)
* [Conference Top Institutions](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/06.%20Conference%20Top%20Institutions)
* [Conference Memory of References](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/07.%20Conference%20Memory%20of%20References)
* [Conference Top Referenced Venues](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/08.%20Conference%20Top%20Referenced%20Venues)
* [Conference Top Citing Venues](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/09.%20Conference%20Top%20Citing%20Venues)
* [Organization Insight](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/tree/master/src/AcademicAnalytics/12.%20Organization%20Insight)

## Getting started with sample projects

1. Download or clone the [samples repository](https://github.com/Azure-Samples/academic-knowledge-analytics-visualization/)
1. Open the solution /src/AcademicAnalytics.sln
1. For each tutorial there should be: A U-SQL script(.usql), a Power BI report (.pbix), a Power BI template (.pbit) and a README explaining the tutorial.
1. In the U-SQL script, replace `<AzureStorageAccount>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample.

   | Value | Description |
   | - | - |
   |**`<AzureStorageAccount>`** | The name of your Azure Storage (AS) account containing MAG dataset. |
   | **`<MagContainer>`** | This is the container name in Azure Storage account containing MAG dataset. See below. |
   | **`<MagVersion>`** | This is the path to a MAG dataset in MagContainer.  See below. |

   <br>

   * If the MAG dataset is from Azure Data Share, set **MagContainer** to the container you created, and **MagVersion** to `'mag/yyyy-mm-dd'`.
   * Otherwise, set **MagContainer** to `'mag-yyyy-mm-dd'`, and **MagVersion** to `''`.

1. Although each tutorial is different, running the U-SQL script as is and filling out the Power BI template using the same U-SQL parameters should give you a Power BI report with visualizations that match the Power BI report example included in the tutorial. Since the Microsoft Academic graph is contently improving, different graph versions may give you slightly different results.

## Working with U-SQL scripts

* How to run U-SQL scripts
  * Make sure you have selected your Data Lake account

    ![Select your Data Lake account in Visual Studio](media/samples-select-data-lake-analytics-account.png "Select your Data Lake account in Visual Studio")

  * Build the script first to validate syntax

    ![Build U-SQL script in Visual Studio](media/samples-build-usql-script.png "Build U-SQL script in Visual Studio")

  * Submit your script to your Data Lake account

    ![Submit U-SQL script in Visual Studio](media/samples-submit-usql-script.png "Submit U-SQL script in Visual Studio")

* How to view U-SQL results in Azure portal

    ![Navigate to the overview tab and click data explorer](media/samples-view-usql-script-results-1.png "Navigate to the overview tab and click data explorer")

    ![Navigate to the output directory specified in the U-SQL script](media/samples-view-usql-script-results-2.png "Navigate to the output directory specified in the U-SQL script")

## Using Power BI

> [!IMPORTANT]
> Make sure U-SQL script finished successfully

* Open up corresponding Power BI Template (.pbit) from file explorer (Visual studio doesn't recognize Power BI files)
* Enter your ADL information and parameters corresponding to your scripts

    ![Load sample Power BI script template](media/configure-power-bi-client.png "Load sample Power BI script template")

* Make sure the parameters cases are the same as your script and "click" to load

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
* [Develop U-SQL scripts by using Data Lake Tools for Visual Studio](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-data-lake-tools-get-started)
* [Get started with U-SQL](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-u-sql-get-started)
* [Deep Dive into Query Parameters and Power BI Templates](https://powerbi.microsoft.com/blog/deep-dive-into-query-parameters-and-power-bi-templates/)
* [Manage Azure Data Lake Store resources by using Storage Explorer](https://docs.microsoft.com/azure/data-lake-store/data-lake-store-in-storage-explorer)
* [Scalable Data Science with Azure Data Lake: An end-to-end walk-through](https://docs.microsoft.com/azure/machine-learning/team-data-science-process/data-lake-walkthrough)
* [Microsoft Academic Website](https://academic.microsoft.com/)
