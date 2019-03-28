---
title: 'Tutorial: Compute author h-index using Azure Databricks'
description: Compute author h-index for Microsoft Academic Graph using Azure Databricks
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 3/26/2019
---
# Tutorial: Compute author h-index using Azure Databricks

In this tutorial, you compute h-index for all authors in Microsoft Academic Graph (MAG) using Azure Databricks. You extract data from Azure Storage into data frames, compute h-index, and visualize the result in table and graph forms.

## Prerequisites

Complete these tasks before you begin this tutorial:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Setting up Azure Databricks service. See [Set up Azure Databricks](get-started-setup-databricks.md).

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The access key of your Azure Storage (AS) account from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

## Import PySparkMagClass.py as a notebook in Azure Databricks

In this section, you import PySparkMagClass.py as a notebook in Azure Databricks workspace. This utility notebook will be called from another notebook later.

1. Save samples\PySparkMagClass.py in MAG dataset to local drive.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Databricks service that you created, and select **Launch Workspace**.

1. On the left, select **Workspace**. From the **Workspace** drop-down, select **Import**.

    ![Import a notebook in Databricks](media/databricks/import-notebook.png "import notebook in Databricks")
    
   > [!NOTE]
   > Please import this notebook under **Workspace** level, not under **Shared** or **Users** level.

1. Drag and drop PySparkMagClass.py to the **Import Notebook** dialog box

    ![Provide details for a notebook in Databricks](media/databricks/import-notebook-dialog.png "Provide details for a notebook in Databricks")

1. Select **Import**. This will create a notebook with path `/PySparkMagClass`. No need to run this notebook.

## Create a notebook in Azure Databricks

In this section, you create a notebook in Azure Databricks workspace.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Databricks service that you created, and select **Launch Workspace**.

1. On the left, select **Workspace**. From the **Workspace** drop-down, select **Create** > **Notebook**.

    ![Create a notebook in Databricks](media/databricks/databricks-create-notebook.png "Create notebook in Databricks")

1. In the **Create Notebook** dialog box, enter a name for the notebook. Select **Python** as the language.

    ![Provide details for a notebook in Databricks](media/databricks/create-notebook.png "Provide details for a notebook in Databricks")

1. Select **Create**.

## Define configration variables

In this section, you create the first notebook cell and define configration variables.

1. Copy and paste following code block into the first cell.

   ```python
   AzureStorageAccount = '<AzureStorageAccount>'     # Azure Storage (AS) account containing MAG dataset
   AzureStorageAccessKey = '<AzureStorageAccessKey>' # Access Key of the Azure Storage (AS) account
   MagContainer = '<MagContainer>'                   # The container name in Azure Storage (AS) account containing MAG dataset, Usually in forms of mag-yyyy-mm-dd

   MagDir = '/mnt/mag'
   ```

1. In this code block, replace `<AzureStorageAccount>`, `<AzureStorageAccessKey>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample.

   |Value  |Description  |
   |---------|---------|
   |**`<AzureStorageAccount>`** | The name of your Azure Storage account. |
   |**`<AzureStorageAccessKey>`** | The access key of your Azure Storage account. |
   |**`<MagContainer>`** | The container name in Azure Storage account containing MAG dataset, Usually in the form of **mag-yyyy-mm-dd**. |

1. Press the **SHIFT + ENTER** keys to run the code in this block.

## Mount Azure Storage as a file system of the cluster

In this section, you mount MAG dataset in Azure Storage as a file system of the cluster.

1. Copy and paste the following code block in a new cell.

   ```
   if (any(mount.mountPoint == MagDir for mount in dbutils.fs.mounts())):
     dbutils.fs.unmount(MagDir)

   dbutils.fs.mount(
     source = ('wasbs://%s@%s.blob.core.windows.net' % (MagContainer, AzureStorageAccount)),
     mount_point = MagDir,
     extra_configs = {('fs.azure.account.key.%s.blob.core.windows.net' % AzureStorageAccount) : AzureStorageAccessKey})

   dbutils.fs.ls(MagDir)
   ```

1. Press the **SHIFT + ENTER** keys to run the code in this block.

   You see an output similar to the following snippet:

   ```
   /mnt/mag has been unmounted.
   Out[4]:
   [FileInfo(path='dbfs:/mnt/mag/advanced/', name='advanced/', size=0),
    FileInfo(path='dbfs:/mnt/mag/mag/', name='mag/', size=0),
    FileInfo(path='dbfs:/mnt/mag/nlp/', name='nlp/', size=0),
    FileInfo(path='dbfs:/mnt/mag/samples/', name='samples/', size=0)]
   ``` 

## Define functions to extract MAG data

In this section, you define functions to extract MAG data from Azure Storage (AS).

1. Paste the following code in a new cell. Press the **SHIFT + ENTER** keys to run the code in this block.

   > [!NOTE]
   > To work with the latest MAG dataset schema, instead of the code block below, you could use code in samples/CreatePySparkFunctions.py in the MAG dataset.

   ```python
   def getAffiliationsDataFrame(dir):
     path = 'mag/Affiliations.txt'
     header = ['AffiliationId', 'Rank', 'NormalizedName', 'DisplayName', 'GridId', 'OfficialPage', 'WikiPage', 'PaperCount', 'CitationCount', 'CreatedDate']
     return spark.read.format('csv').options(header='false', inferSchema='true', delimiter='\t').load('%s/%s' % (dir, path)).toDF(*header)

   def getAuthorsDataFrame(dir):
     path = 'mag/Authors.txt'
     header = ['AuthorId', 'Rank', 'NormalizedName', 'DisplayName', 'LastKnownAffiliationId', 'PaperCount', 'CitationCount', 'CreatedDate']
     return spark.read.format('csv').options(header='false', inferSchema='true', delimiter='\t').load('%s/%s' % (dir, path)).toDF(*header)

   def getPaperAuthorAffiliationsDataFrame(dir):
     path = 'mag/PaperAuthorAffiliations.txt'
     header = ['PaperId', 'AuthorId', 'AffiliationId', 'AuthorSequenceNumber', 'OriginalAuthor', 'OriginalAffiliation']
     return spark.read.format('csv').options(header='false', inferSchema='true', delimiter='\t').load('%s/%s' % (dir, path)).toDF(*header)

   def getPapersDataFrame(dir):
     path = 'mag/Papers.txt'
     header = ['PaperId', 'Rank', 'Doi', 'DocType', 'PaperTitle', 'OriginalTitle', 'BookTitle', 'Year', 'Date', 'Publisher', 'JournalId', 'ConferenceSeriesId', 'ConferenceInstanceId', 'Volume', 'Issue', 'FirstPage', 'LastPage', 'ReferenceCount', 'CitationCount', 'EstimatedCitation', 'OriginalVenue', 'CreatedDate']
     return spark.read.format('csv').options(header='false', inferSchema='true', delimiter='\t').load('%s/%s' % (dir, path)).toDF(*header)
   ```

## Create data frames and temporary views

In this section you will create data frames and temporary views for several different MAG entity types. These views will be used later on in the tutorial. Note that some of the cells might take several minutes to run.

1. Get **Affiliations**. Paste the following code in a new cell.

   ```python
   # Get affiliations
   Affiliations = getAffiliationsDataFrame(MagDir)
   Affiliations = Affiliations.select(Affiliations.AffiliationId, Affiliations.DisplayName)
   Affiliations.show(10)
   Affiliations.createOrReplaceTempView('Affiliations')
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see an output similar to the following snippet:

   ```
   +-------------+--------------------+
   |AffiliationId|         DisplayName|
   +-------------+--------------------+
   |     20455151|         Air Liquide|
   |     24386293|Hellenic National...|
   |     32956416|Catholic Universi...|
   ...
   ...
   ``` 

1. Get **Authors**. Paste the following code in a new cell.

   ```python
   # Get authors
   Authors = getAuthorsDataFrame(MagDir)
   Authors = Authors.select(Authors.AuthorId, Authors.DisplayName, Authors.LastKnownAffiliationId, Authors.PaperCount)
   Authors.show(10)
   Authors.createOrReplaceTempView('Authors')
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see an output similar to the following snippet:

   ```
   +--------+--------------------+----------------------+----------+
   |AuthorId|         DisplayName|LastKnownAffiliationId|PaperCount|
   +--------+--------------------+----------------------+----------+
   |     584|Gözde Özdikmenli-...|              79946792|         2|
   |     859|          Gy. Tolmár|                  null|         2|
   |     978|      Ximena Faúndez|             162148367|        18|
   ...
   ``` 

1. Get **(Author, Paper) pairs**. Paste the following code in a new cell.

   ```python
   # Get (author, paper) pairs
   PaperAuthorAffiliations = getPaperAuthorAffiliationsDataFrame(MagDir)
   AuthorPaper = PaperAuthorAffiliations.select(PaperAuthorAffiliations.AuthorId, PaperAuthorAffiliations.PaperId).distinct()
   AuthorPaper.show(10)
   AuthorPaper.createOrReplaceTempView('AuthorPaper')
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see an output similar to the following snippet:

   ```
   +----------+--------+
   |  AuthorId| PaperId|
   +----------+--------+
   |2121966975|94980387|
   |2502082315|94984326|
   |2713129682|94984597|
   ...
   ...
   ``` 

1. Get **Papers**. Paste the following code in a new cell.

   ```python
   # Get paper citation
   Papers = getPapersDataFrame(MagDir)
   PaperCitation = Papers.select(Papers.PaperId, Papers.EstimatedCitation).where(Papers.EstimatedCitation > 0)
   PaperCitation.show(10)
   PaperCitation.createOrReplaceTempView('PaperCitation')
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see an output similar to the following snippet:

   ```
   +----------+-----------------+
   |   PaperId|EstimatedCitation|
   +----------+-----------------+
   |2088151486|               61|
   |2864100843|                1|
   |2260674751|                5|
   ...
   ...
   ``` 

   You have now extracted MAG data from Azure Storage into Azure Databricks and created temporary views to use later.

## Compute author h-index

In this section, you compute h-index for all authors.

1. **Create an author-paper-citation view**. Paste the following code in a new cell.

   ```sql
   %sql
   -- Generate author, paper, citation view
   CREATE OR REPLACE TEMPORARY VIEW AuthorPaperCitation
       AS SELECT
           A.AuthorId,
           A.PaperId,
           P.EstimatedCitation
       FROM AuthorPaper AS A
       INNER JOIN PaperCitation AS P
           ON A.PaperId == P.PaperId;
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see following output:

   ```
   OK
   ```

1. **Order AuthorPaperCitation view by citation**. Paste the following code in a new cell.

   ```sql
   %sql
   -- Order author, paper, citation view by citation
   CREATE OR REPLACE TEMPORARY VIEW AuthorPaperOrderByCitation
       AS SELECT
           AuthorId,
           PaperId,
           EstimatedCitation,
           ROW_NUMBER() OVER(PARTITION BY AuthorId ORDER BY EstimatedCitation DESC) AS Rank
       FROM AuthorPaperCitation;
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see following output:

   ```
   OK
   ```

1. **Compute h-index for all authors**. Paste the following code in a new cell.

   ```sql
   %sql
   -- Generate author hindex
   CREATE OR REPLACE TEMPORARY VIEW AuthorHIndexTemp
       AS SELECT
           AuthorId,
           SUM(EstimatedCitation) AS TotalEstimatedCitation,
           MAX(CASE WHEN EstimatedCitation >= Rank THEN Rank ELSE 0 END) AS HIndex
       FROM AuthorPaperOrderByCitation 
       GROUP BY AuthorId;
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see following output:

   ```
   OK
   ```

1. **Get author detail information**. Paste the following code in a new cell.

   ```sql
   %sql
   -- Get author detail information
   CREATE OR REPLACE TEMPORARY VIEW AuthorHIndex
       AS SELECT
           I.AuthorId,
           A.DisplayName,
           AF.DisplayName AS AffiliationDisplayName,
           A.PaperCount,
           I.TotalEstimatedCitation,
           I.HIndex
       FROM AuthorHIndexTemp AS I
       INNER JOIN Authors AS A
           ON A.AuthorId == I.AuthorId
       LEFT OUTER JOIN Affiliations AS AF
           ON A.LastKnownAffiliationId == AF.AffiliationId;
   ```

   Press the **SHIFT + ENTER** keys to run the code in this block. You see following output:

   ```
   OK
   ```

## Query and visualize result 

In this section, you query top authors by h-index and visualize the result.

1. Query top authors with highest h-index. Paste the following code in a new cell. Press the **SHIFT + ENTER** keys to run the code in this block.

   ```sql
   %sql
   -- Filter authors with top hindex
   SELECT
       DisplayName,
       AffiliationDisplayName,
       PaperCount,
       TotalEstimatedCitation,
       HIndex
   FROM AuthorHIndex 
   ORDER BY HIndex DESC, AuthorId
   LIMIT 100;
   ```

1. Select the **table** icon to see result in table form.

   ![Author H-Index table](media/databricks/hindex-table.png "Verify sample table")

1. Select the **graph** icon to see result in graph form.

   ![Author H-Index graph](media/databricks/hindex-graph.png "Verify sample table")

## Clean up resources

After you finish the tutorial, you can terminate the cluster. From the Azure Databricks workspace, select **Clusters** on the left. For the cluster to terminate, under **Actions**, point to the ellipsis (...) and select the **Terminate** icon.

![Stop a Databricks cluster](media/databricks/terminate-databricks-cluster.png "Stop a Databricks cluster")

If you don't manually terminate the cluster, it automatically stops, provided you selected the **Terminate after \_\_ minutes of inactivity** check box when you created the cluster. In such a case, the cluster automatically stops if it's been inactive for the specified time.

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/).
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html).
* [Import this notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook).
* [H-index](https://en.wikipedia.org/wiki/H-index)
