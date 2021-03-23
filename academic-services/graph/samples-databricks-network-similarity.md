---
title: Network Similarity Sample (PySpark)
description: Network Similarity Sample (PySpark)
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 3/23/2021
---
# Network Similarity Sample (PySpark)

In this sample, you will compute the network similarity score and top related entities using Azure Databricks.

## Prerequisites

Complete these tasks before you begin this sample.

* Set up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Set up an Azure Databricks service. See [Set up Azure Databricks](get-started-setup-databricks.md).

## Gather the information

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name).

   :heavy_check_mark:  The access key of your Azure Storage (AS) account from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

   :heavy_check_mark:  The path to a MAG dataset in the container.

## Import MagClass notebook

In this section, you will import the MagClass notebook into Azure Databricks workspace. You will include this notebook in this sample later.

Follow instructions in [Import MagClass Notebook](import-magclass.md).

## Import NetworkSimilarityClass notebook

In this section, you will import the NetworkSimilarityClass notebook into Azure Databricks workspace. You will include this notebook in this sample later.

1. Download `ns/pyspark/NetworkSimilarityClass.py` in MAG dataset to your local drive.<br>From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [mag-yyyy-mm-dd] > ns > pyspark > NetworkSimilarityClass.py > Download**.

1. In the Azure Databricks workspace portal, from **Workspace** > **Users** > **Your folder** drop-down, select **Import**.

1. Drag and drop `NetworkSimilarityClass.py` to the **Import Notebook** dialog box.

1. Select **Import**. No need to run this notebook.

## Import NetworkSimilaritySample notebook

In this section, you will import the NetworkSimilaritySample.py as a notebook in the Azure Databricks workspace and run the notebook.

1. Download `ns/pyspark/NetworkSimilaritySample.py` in MAG dataset to your local drive.<br>From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [mag-yyyy-mm-dd] > ns > pyspark > NetworkSimilaritySample.py > Download**.

1. In the Azure Databricks workspace portal, from the **Workspace** > **Users** > **Your folder** drop-down, select **Import**.

1. Drag and drop NetworkSimilaritySample.py to the **Import Notebook** dialog box.

1. Select **Import**.

## Initialize storage account and container details

Replace values for following variables.

  | Variable | Value | Description |
  | - | - | - |
  | AzureStorageAccount | Replace **`<AzureStorageAccount>`** | This is the Azure Storage account containing MAG dataset. |
  | AzureStorageAccessKey | Replace **`<AzureStorageAccessKey>`** | This is the Access Key of the Azure Storage account. |
  | MagContainer | Replace **`<MagContainer>`** | This is the container name in Azure Storage account containing MAG dataset. See below. |
  | MagVersion | Replace **`<MagVersion>`** | This is the path to a MAG dataset in MagContainer.  See below. |
  | EntityType | 'affiliation' | See [documentation](network-similarity.md#available-senses) for available entity types. Replace with other entity type if needed. |
  | Sense | 'metapath' | See [documentation](network-similarity.md#available-senses) for available senses. Replace with other sense if needed. |
  | EntityId1 | 1290206253 | Entity id of Microsoft. Replace with other entity id if needed. |
  | EntityId2 | 201448701 | Entity id of University of Washington. Replace with other entity id if needed. |

  <br>
  
  - If the MAG dataset is from Azure Data Share, set **MagContainer** to the container you created, and **MagVersion** to `'mag/yyyy-mm-dd'`.
  - Otherwise, set **MagContainer** to `'mag-yyyy-mm-dd'`, and **MagVersion** to `''`.

   ```python
   AzureStorageAccount = '<AzureStorageAccount>'
   AzureStorageAccessKey = '<AzureStorageAccessKey>'
   MagContainer = '<MagContainer>'
   MagVersion = '<MagVersion>'

   EntityType = 'affiliation'
   Sense = 'metapath'
   EntityId1 = 1290206253
   EntityId2 = 201448701
   ```

## Run the notebook

1. Click the **Run All** button.

## Notebook description

#### Define MicrosoftAcademicGraph class

Run the MagClass notebook to define MicrosoftAcademicGraph class.

   ```python
   %run "./MagClass"
   ```

#### Define NetworkSimilarity class

Run NetworkSimilarityClass notebook to define NetworkSimilarity class.

   ```python
   %run "./NetworkSimilarityClass"
   ```

#### Create a MicrosoftAcademicGraph instance to access MAG dataset

Use account=AzureStorageAccount, key=AzureStorageAccessKey, container=MagContainer, version=MagVersion

   ```python
   MAG = MicrosoftAcademicGraph(account=AzureStorageAccount, key=AzureStorageAccessKey, container=MagContainer, version=MagVersion)
   ```

#### Create a NetworkSimilarity instance to compute similarity

Use mag=MAG, entitytype=EntityType, sense=Sense

   ```python
   NS = NetworkSimilarity(mag=MAG, entitytype=EntityType, sense=Sense)
   ```

#### Compute the similarity score between two entities: getSimilarity()

   ```python
   score = NS.getSimilarity(EntityId1, EntityId2)
   print(score)
   ```

- You will see output as follows

    > 0.7666980387511901

#### Get top related entities: getTopEntities()

   ```python
   topEntities = NS.getTopEntities(EntityId1)
   display(topEntities)
   ```

- You will see output as follows

    ![GetTopEntities output](media/network-similarity/databricks-get-top-entities.png "GetTopEntities output")


#### Display entity details

Join topEntities with affiliations for display names

   ```python
   # Get authors dataframe
   affiliations = MAG.getDataframe('Affiliations')

   # Join top entities with authors to show auhtor names
   topEntitiesWithName = topEntities \
      .join(affiliations, topEntities.EntityId == affiliations.AffiliationId, 'inner') \
      .select(topEntities.EntityId, affiliations.DisplayName, topEntities.Score) \
      .orderBy(topEntities.Score.desc())
   display(topEntitiesWithName)
   ```

- You will see output as follows

    ![Top entities detail](media/network-similarity/databricks-top-entities-detail.png "Top entities detail")

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/)
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html)
* [Import this notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook)
