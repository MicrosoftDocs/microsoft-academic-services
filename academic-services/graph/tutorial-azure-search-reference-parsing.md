---
title: Academic reference parsing using Azure Search
description: Set up Azure Search service to enable reference parsing using the Microsoft Academic Graph
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 3/18/2019
---

# Tutorial: Set up organizational patent search with Azure Search

Step-by-step instructions for setting up an Azure Search service to enable academic reference parsing using data from the Microsoft Academic Graph.

> [!WARNING]
> This is an **advanced** tutorial that creates an Azure Search service that indexes **all of the papers in the Microsoft Academic Graph**.
>
> Because of the scope of the data being indexed, it requires a significant amount of time and resource use to complete.

## Prerequisites

Complete these tasks before beginning this tutorial:

* [Set up provisioning of Microsoft Academic Graph to an Azure blob storage account](get-started-setup-provisioning.md)
* [Set up Azure Data Lake Analytics for Microsoft Academic Graph](get-started-setup-azure-data-lake-analytics.md)
* [Install Postman desktop app](https://www.getpostman.com/)

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

   :heavy_check_mark:  The name of your Azure Data Lake Analytics (ADLA) service from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md).

   :heavy_check_mark:  The name of your Azure Data Lake Storage (ADLS) from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md).

   :heavy_check_mark:  The name of the container in your Azure Storage account containing the MAG data set.

   :heavy_check_mark:  The connection string of your Azure Storage account containing the MAG data set. It should look similar to ```DefaultEndpointsProtocol=https;AccountName=<AzureStorageAccountName>;AccountKey=<AzureStorageAccountKey>;EndpointSuffix=core.windows.net```

## Generate text documents for academic papers

In prerequisite [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md), you added the Azure Storage (AS) created for MAG provision as a data source for the Azure Data Lake Analytics service (ADLA). In this section, you submit an ADLA job to generate text files containing academic data that will be used to create an Azure Search service.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview** > **New Job**.

   ![Azure Data Lake Analytics - New job](media/samples-azure-data-lake-hindex/new-job.png)

1. Copy and paste the following code block in the script window.

```U-SQL
SET @@FeaturePreviews = "DataPartitionedOutput:on";

// Make sure to run CreateFunctions script from common scripts first!

DECLARE @azureSearchIndexerCount int = 36;
DECLARE @dataPartitionCount int = 100;

DECLARE @blobAccount string = "<AzureStorageAccount>";
DECLARE @dataVersion string = "<MagContainer>";

DECLARE @uriPrefix string = "wasb://" + @dataVersion + "@" + @blobAccount + "/";
DECLARE @output = "wasb://" + @dataVersion + "@" + @blobAccount + "/azure-search-data/{PartitionNumber}-data.{ForIndexerNumber}";

//
// Load academic data
//
@papers =
    Papers
    (
        @uriPrefix
    );

@papers =
    SELECT *,
           (JournalId == null? (long) - 1 : JournalId.Value) AS JId,
           (ConferenceSeriesId == null? (long) - 1 : ConferenceSeriesId.Value) AS CId
    FROM @papers;

@paperAuthorAffiliations =
    PaperAuthorAffiliations
    (
        @uriPrefix
    );

@paperAuthorAffiliations =
    SELECT *,
           (AffiliationId == null? (long) - 1 : AffiliationId.Value) AS AfId
    FROM @paperAuthorAffiliations;

@authors =
    Authors
    (
        @uriPrefix
    );

@journals =
    Journals
    (
        @uriPrefix
    );

@conferenceSeries =
    ConferenceSeries
    (
        @uriPrefix
    );

//
// Flatten paper authors into a string associated with each paper
//
@paperAuthorsDistinct =
    SELECT DISTINCT A.PaperId,
                    A.AuthorId,
                    A.AuthorSequenceNumber
    FROM @paperAuthorAffiliations AS A
    INNER JOIN @papers AS P
        ON A.PaperId == P.PaperId
    OPTION(ROWCOUNT=500000000);

@paperAuthors =
    SELECT P.PaperId,
           A.NormalizedName AS AuthorName,
           P.AuthorSequenceNumber
    FROM @paperAuthorsDistinct AS P
         INNER JOIN
             @authors AS A
         ON P.AuthorId == A.AuthorId
    OPTION(ROWCOUNT=500000000);

@paperAuthorsAggregated =
    SELECT PaperId,
           "[" + string.Join(",", MAP_AGG("\"" + AuthorName + "\"", AuthorSequenceNumber).OrderBy(a => a.Value).Select(a => a.Key)) + "]" AS Authors
    FROM @paperAuthors
    GROUP BY PaperId
    OPTION(ROWCOUNT=200000000);

//
// Generate tab delimited files containing the partitioned academic data we filtered/flattened above
//
@paperDocumentFields =
    SELECT P.PaperId,
           P.Rank,
           P.Year,
           (P.JournalId == null?null : J.NormalizedName) AS Journal,
           (P.ConferenceSeriesId == null?null : C.NormalizedName) AS Conference,
           A.Authors,
           P.Volume,
           P.Issue,
           P.FirstPage,
           P.LastPage,
           P.PaperTitle,
           P.Doi,
           (int) (P.PaperId % @azureSearchIndexerCount) AS ForIndexerNumber,
           (int) (P.PaperId % @dataPartitionCount) AS PartitionNumber
    FROM @papers AS P
         LEFT OUTER JOIN
             @journals AS J
         ON P.JId == J.JournalId
         LEFT OUTER JOIN
             @conferenceSeries AS C
         ON P.CId == C.ConferenceSeriesId
         LEFT OUTER JOIN
             @paperAuthorsAggregated AS A
         ON P.PaperId == A.PaperId
    OPTION(ROWCOUNT=200000000);

//
// Generates partitioned files based on the values in the ForIndexerNumber and PartitionNumber columns
// 
OUTPUT @paperDocumentFields
TO @output
USING Outputters.Tsv(quoting : false);

```

1. In this code block, replace `<AzureStorageAccount>`, and `<MagContainer>` placeholder values with the values that you collected while completing the prerequisites of this sample

   |Value  |Description  |
   |---------|---------|
   |**`<AzureStorageAccount>`** | The name of your Azure Storage (AS) account containing MAG dataset. |
   |**`<MagContainer>`** | The container name in Azure Storage (AS) account containing MAG dataset, Usually in the form of **mag-yyyy-mm-dd**. |

1. Provide a **Job name**, change **AUs** to 50, and select **Submit**

   ![Submit GenerateAzureSearchData job](media/tutorial-search-submit-usql.png)

1. The job should finish successfully in about 20 minutes

   ![GenerateAzureSearchData job status](media/tutorial-search-usql-status.png)

## Create Azure Search service

1. Go to the Azure Management Portal and create a new Azure Search service

   ![Create new Azure Search service](media/tutorial-search-new-service.png)

1. Enter information for a new service then click the create button

    ![Enter information for a new service](media/tutorial-search-create-service.png)

    1. Enter a unique name for the service
    1. Create a new resource group for the service with the same name as the service
    1. To ensure the best performance, use the same location as the Azure storage account containing the Microsoft Academic Graph data
    1. Use the "standard" price tier

1. Once the new service has been created, navigate to the overview section of the service and get the URL
1. Navigate to the keys section of the service and get the primary admin key

## Configure initial Postman request

For each step in the sections below we will be re-using the same Postman request, which means we only need to configure the URL endpoint, api-version, api-key, and content-type once.

The full URL should look similar to the following example, only yours should have a valid replacement for the ```my-search-service``` placeholder name: ```https://my-search-service.search.windows.net/resource?api-version=2017-11-11```

Service URL composition includes the following components

* HTTPS prefix
* Service URL, obtained from the overview section of your service on the portal
* Resource, an operation that creates an object on your service
* api-version, a required lowercase string specified as "?api-version=2017-11-11" for the current version

Postman should populate a default "get" request when initially opened, similar to the following:

![Default Postman request](media/tutorial-search-postman-default.png)

Change the action verb from GET to POST, the request URL to the service URL detailed above and add the following two header key/value pairs

* ```api-key: <AzureSearchServiceAdminKey>```
* ```Content-Type: application/json```

This should result in a Postman request similar to the following:

![Postman request template](media/tutorial-search-postman-template.png)

## Create data source

* Keep the request headers and action verb as-is
* Change the resource to ```/datasources```. The full URL should look like
```https://my-search-service.search.windows.net/datasources?api-version=2017-11-11```
* Click the "Body" tab in the request and copy/paste the JSON below, changing "<AzureStorageAccountConnectionString>" and "<MagContainer>" to the values for your Azure Storage Account and MAG containers, respectively

    ```JSON
    {
        "name" : "azure-search-data",
        "type" : "azureblob",
        "credentials" : { "connectionString" : "<AzureStorageAccountConnectionString>" },
        "container" : { "name" : "<MagContainer>", "query" : "azure-search" }
    }
    ```

* Click the "Send" button

You should receive a "201 created" response similar to the following:

![Postman response template](media/tutorial-search-postman-response.png)

## Create index

* Keep the request headers and action verb as-is
* Change the resource to ```/indexes```. The full URL should look like
```https://my-search-service.search.windows.net/indexes?api-version=2017-11-11```
* Change request body to the following JSON

    ```JSON
    {
        "name": "mag-index",  
        "fields": [
            {"name": "id", "type": "Edm.String", "key": true, "filterable": false, "searchable": false, "sortable": false, "facetable": false},
            {"name": "rank", "type": "Edm.Int32", "filterable": true, "searchable": false, "facetable": false, "sortable": true},
            {"name": "year", "type": "Edm.String", "filterable": true, "searchable": true, "facetable": false, "sortable": false},
            {"name": "journal", "type": "Edm.String", "filterable": true, "searchable": true, "facetable": false, "sortable": false},
            {"name": "conference", "type": "Edm.String", "filterable": true, "searchable": true, "facetable": false, "sortable": false},
            {"name": "authors", "type": "Collection(Edm.String)", "filterable": true, "searchable": true, "facetable": false, "sortable": false},
            {"name": "volume", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false},
            {"name": "issue", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false},
            {"name": "first_page", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false},
            {"name": "last_page", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false},
            {"name": "title", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false},
            {"name": "doi", "type": "Edm.String", "filterable": false, "searchable": true, "facetable": false, "sortable": false}
        ]
    }
    ```

* Click the "Send" button

## Create indexers

The Microsoft Academic Graph has well over 200 million papers, which can take a considerable amount of time to index. To help reduce the amount of time taken to index the papers we create **four indexers** each targeting a specific subset of the text documents generated earlier.

* Keep the request headers and action verb as-is
* Change the resource to ```/indexers```. The full URL should look like
```https://my-search-service.search.windows.net/indexers?api-version=2017-11-11```
* Change the request body to the following JSON and click the "send" button

    ```JSON
    {
        "name" : "mag-indexer-1",
        "dataSourceName" : "azure-search-data",
        "targetIndexName" : "mag-index",
        "schedule" : {
            "interval" : "PT5M"
        },
        "parameters" : {
            "configuration" : {
                "parsingMode" : "delimitedText",
                "delimitedTextHeaders" : "id,rank,year,journal,conference,authors,volume,issue,first_page,last_page,title,doi",
                "delimitedTextDelimiter": "	",
                "firstLineContainsHeaders": false,
                "indexedFileNameExtensions": ".0"
            }
        }
    }
    ```

* Change the request body to the following JSON and click the "send" button

    ```JSON
    {
        "name" : "mag-indexer-2",
        "dataSourceName" : "azure-search-data",
        "targetIndexName" : "mag-index",
        "schedule" : {
            "interval" : "PT5M"
        },
        "parameters" : {
            "configuration" : {
                "parsingMode" : "delimitedText",
                "delimitedTextHeaders" : "id,rank,year,journal,conference,authors,volume,issue,first_page,last_page,title,doi",
                "delimitedTextDelimiter": "	",
                "firstLineContainsHeaders": false,
                "indexedFileNameExtensions": ".1"
            }
        }
    }
    ```

* Change the request body to the following JSON and click the "send" button

    ```JSON
    {
        "name" : "mag-indexer-3",
        "dataSourceName" : "azure-search-data",
        "targetIndexName" : "mag-index",
        "schedule" : {
            "interval" : "PT5M"
        },
        "parameters" : {
            "configuration" : {
                "parsingMode" : "delimitedText",
                "delimitedTextHeaders" : "id,rank,year,journal,conference,authors,volume,issue,first_page,last_page,title,doi",
                "delimitedTextDelimiter": "	",
                "firstLineContainsHeaders": false,
                "indexedFileNameExtensions": ".2"
            }
        }
    }
    ```

* Change the request body to the following JSON and click the "send" button

    ```JSON
    {
        "name" : "mag-indexer-4",
        "dataSourceName" : "azure-search-data",
        "targetIndexName" : "mag-index",
        "schedule" : {
            "interval" : "PT5M"
        },
        "parameters" : {
            "configuration" : {
                "parsingMode" : "delimitedText",
                "delimitedTextHeaders" : "id,rank,year,journal,conference,authors,volume,issue,first_page,last_page,title,doi",
                "delimitedTextDelimiter": "	",
                "firstLineContainsHeaders": false,
                "indexedFileNameExtensions": ".3"
            }
        }
    }
    ```

## Scale up the service

In addition to creating multiple indexers, we also need to scale up the services search units (SU) so ensure that each indexer can be run concurrently and that there is sufficient space to store the index.

To do this, navigate to the scale section of the service and change the number of partitions to 6 and number of replicas to 4, then click the "save" button

![Scale up service](media/tutorial-search-scale-up-service.png)

> [!IMPORTANT]
> The scale operation may take **an hour or more to complete** and the service may be unavailable while the operation is completing.

## Waiting for indexers to complete

The indexing operation can take a long time to complete, likely between 8-12 hours.

The indexers will each show a "success" status once they have completed indexing their respective sections, and the index should show a document count roughly equal to the total number of papers in the graph (you can see the most current count by visiting [Microsoft Academic](https://academic.microsoft.com/)).

## Scale down the service

Once the indexers have completed, you can optionally scale the service back down by reducing the number of replicas and partitions.

> [!WARNING]
> It's important to note that you should not reduce the number of partitions below the number required to hold the indexed data. Doing so would result in documents being removed from the index, which would in turn reduce the accuracy of search operations.

> [!TIP]
> The performance of individual search queries can be improved by increasing the number of partitions, and likewise the number of concurrent search requests (throughput) can be improved by increasing the number of replicas. For more details about Azure Search performance, please see [Scale partitions and replicas for query and indexing workloads](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning)

## Query the Azure Search service

Once the indexer has completed, you can immediately begin querying the service by clicking the "Search explorer" button from the overview section:

![Load search explorer](media/tutorial-search-load-search-explorer.png)

### Example: Patents about search indexers

![Searching for patents about search indexers](media/tutorial-search-example-search-indexer.png)

### Example: Patents about face recognition and AI created before 2000

![Load search explorer](media/tutorial-search-example-face-recognition.png)

> [!NOTE]
> This example makes use of filter expressions to restrict which content is considered before looking for the search terms. See the [Azure Search filter expression](https://docs.microsoft.com/en-us/azure/search/search-explorer#filter-expressions-greater-than-less-than-equal-to) documentation for more details.

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
* [Data Lake Analytics](https://azure.microsoft.com/services/data-lake-analytics/)
* [U-SQL Language Reference](https://docs.microsoft.com/u-sql/)
* [Azure Search](https://docs.microsoft.com/en-us/azure/search/)