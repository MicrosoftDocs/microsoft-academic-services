---
title: Network Similarity Sample (PySpark)
description: Network Similarity Sample (PySpark)
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# Network Similarity Sample (PySpark)

In this sample, you compute network similarity score and top related entities in Microsoft Academic Graph (MAG) using Azure Databricks.

## Prerequisites

Complete these tasks before you begin this tutorial:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Setting up Azure Databricks service. See [Set up Azure Databricks](get-started-setup-databricks.md).

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The access key of your Azure Storage (AS) account from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

## Import PySparkMagClass notebook

In this section, you import PySparkMagClass.py notebook to Azure Databricks workspace. You will include this notebook in this sample later.

Follow instructions in [Import PySparkMagClass Notebook](import-pysparkmagclass.md).

## Import PySparkNetworkSimilarityClass notebook

In this section, you import PySparkNetworkSimilarityClass.py notebook to Azure Databricks workspace. You will include this notebook in this sample later.

1. Save **`ns/PySparkNetworkSimilarityClass.py`** in MAG dataset to local drive.

1. In Azure Databricks workspace portal, from **Workspace** > **Shared** drop-down, select **Import**.

1. Drag and drop PySparkNetworkSimilarityClass.py to the **Import Notebook** dialog box.

1. Select **Import**. This will create a notebook with path `"/Shared/PySparkNetworkSimilarityClass"`. No need to run this notebook.

## Import NetworkSimilaritySample notebook

In this section, you import NetworkSimilaritySample.py as a notebook in Azure Databricks workspace and run the notebook.

1. Save **`ns/NetworkSimilaritySample.py`** in MAG dataset to local drive.

1. In Azure Databricks workspace portal, from the **Workspace** > **Users** > **Your folder** drop-down, select **Import**.

1. Drag and drop NetworkSimilaritySample.py to the **Import Notebook** dialog box.

1. Replace `<AzureStorageAccount>`, `<AzureStorageAccessKey>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample.

   |Value  |Description  |
   |---------|---------|
   |**`<AzureStorageAccount>`** | The name of your Azure Storage account. |
   |**`<AzureStorageAccessKey>`** | The access key of your Azure Storage account. |
   |**`<MagContainer>`** | The container name in Azure Storage account containing MAG dataset, usually in the form of **mag-yyyy-mm-dd**. |

1. Click **Run All** button.

## Notebook description

### Network Similarity Sample

In this sample, you compute network similarity score and top related entities using Azure Databricks.

### Prerequisites

To run this notebook:
- [Create an Azure Databricks service](https://azure.microsoft.com/en-us/services/databricks/).
- [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html).
- [Import](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook) samples/PySparkMagClass.py under your working folder.
- [Import](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook) ns/PySparkNetworkSimilarityClass.py under the same folder.
- [Import](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook) this notebook under the same folder.

### Set up the storage account and container details

- Replace **`<AzureStorageAccount>`**. This is the Azure Storage account containing MAG dataset.
- Replace **`<AzureStorageAccessKey>`**. This is the Access Key of the Azure Storage account.
- Replace **`<MagContainer>`**. This is the container name in Azure Storage account containing MAG dataset, usually in the form of mag-yyyy-mm-dd.

   ```python
   AzureStorageAccount = '<AzureStorageAccount>'     # Azure Storage (AS) account containing MAG dataset
   AzureStorageAccessKey = '<AzureStorageAccessKey>' # Access Key of the Azure Storage (AS) account
   MagContainer = '<MagContainer>'                   # The container name in Azure Storage (AS) account containing MAG dataset, usually in the form of mag-yyyy-mm-dd

   EntityType = 'affiliation'                        # See document for available entity types. Replace with other entity type if needed.
   Sense = 'metapath'                                # See document for available senses. Replace with other sense if needed.
   EntityId1 = 1290206253                            # Entity id of Microsoft. Replace with other entity id if needed
   EntityId2 = 201448701                             # Entity id of University of Washington. Replace with other entity id if needed
   ```

### Define MicrosoftAcademicGraph class

Run PySparkMagClass notebook to define MicrosoftAcademicGraph class.

   ```python
   %run "./PySparkMagClass"
   ```

### Define NetworkSimilarity class

Run PySparkNetworkSimilarityClass notebook to define NetworkSimilarity class.

   ```python
   %run "./PySparkNetworkSimilarityClass"
   ```

### Create a MicrosoftAcademicGraph instance to access MAG dataset

   ```python
   MAG = MicrosoftAcademicGraph(container=MagContainer, account=AzureStorageAccount, key=AzureStorageAccessKey)
   ```

### Create a NetworkSimilarity instance to compute similarity

   ```python
   NS = NetworkSimilarity(mag=MAG, entitytype=EntityType, sense=Sense)
   ```

### Call getSimilarity()

   ```python
   score = NS.getSimilarity(EntityId1, EntityId2)
   print(score)
   ```

- You will see output as follows

    > 0.7666980387511901

### Call getTopEntities()

   ```python
   topEntities = NS.getTopEntities(EntityId1)
   display(topEntities)
   ```

- You will see output as follows

    ![GetTopEntities output](media/network-similarity/databricks-get-top-entities.png "GetTopEntities output")


### Display entity details

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

- You will see output for Cmd 8 as follows

    ![Top entities detail](media/network-similarity/databricks-top-entities-detail.png "Top entities detail")

## Clean up resources

After you finish the tutorial, you can terminate the cluster. From the Azure Databricks workspace, select **Clusters** on the left. For the cluster to terminate, under **Actions**, point to the ellipsis (...) and select the **Terminate** icon.

If you don't manually terminate the cluster, it automatically stops, provided you selected the **Terminate after \_\_ minutes of inactivity** check box when you created the cluster. In such a case, the cluster automatically stops if it's been inactive for the specified time.

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/)
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html)
* [Import this notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook)
