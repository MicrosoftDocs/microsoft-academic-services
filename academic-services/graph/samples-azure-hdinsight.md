---
title: PySpark samples for Microsoft Academic Graph
description: Perform analytics for Microsoft Academic Graph using PySpark on Azure Databricks
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 3/26/2019
---
# PySpark analytics samples for Microsoft Academic Graph

Illustrates how to perform analytics for Microsoft Academic Graph using PySpark on Azure Databricks.

## Sample projects

* [Extract Affiliation ID for an Affiliation](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab1_ExtractAffiliation.py)
* [Join Conferences and Journals as Venues](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab2_UnionVenues.py)
* [Get publications from an Affiliation](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab3_JoinPaperAuthorAffiliation.py)
* [Get authors from an Affiliation and the publication details](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab4_CreateTable_Extract.py)
* [Get Field-Of-Studies for an Affiliation](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab5_CreateTableByTvf.py)
* [Get collaborated affiliations of an Affiliation using its publications](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab6_GetPartnerData.py)
* [Get publication and citation counts by year](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab7_GroupByYear.py)

## Getting started with sample projects

### Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Setting up Azure Databricks service. See [Set up Azure Databricks](get-started-setup-databricks.md).

### Gather the information that you need

Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The access key of your Azure Storage (AS) account from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

   :heavy_check_mark:  The name of the output container in your Azure Storage (AS) account.

### Quick-start

1. Download or clone the [samples repository](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples)
1. [Create a notebook](https://docs.azuredatabricks.net/user-guide/notebooks/notebook-manage.html#create-a-notebook) and run `samples/CreatePySparkFunctions.py` in your MAG dataset.
1. [Create a notebook](https://docs.azuredatabricks.net/user-guide/notebooks/notebook-manage.html#create-a-notebook) and run `src\Lab0_Setup.py` before you run other scripts.

## Working with PySpark scripts on Azure Databricks

### Create a notebook in Azure Databricks

1. In the [Azure portal](https://portal.azure.com), go to the Azure Databricks service that you created, and select **Launch Workspace**.

1. On the left, select **Workspace**. From the **Workspace** drop-down, select **Create** > **Notebook**.

    ![Create a notebook in Databricks](media/databricks/databricks-create-notebook.png "Create notebook in Databricks")

1. In the **Create Notebook** dialog box, enter a name for the notebook. Select **Python** as the language.

    ![Provide details for a notebook in Databricks](media/databricks/create-notebook.png "Provide details for a notebook in Databricks")

### Run lab script

1. Copy the lab script  in a new cell.

1. Press the **SHIFT + ENTER** keys to run the code in this block. Please note taht some scripts take more than 10 minutes to run.

### View results with Microsoft Azure Storage Explorer

![View result with Microsoft Azure Storage Explorer](media/samples-view-pyspark-script-results.png "View result with Microsoft Azure Storage Explorer")

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/).
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html).
* [Import this notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook).
* [Get started with Storage Explorer](https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer)
