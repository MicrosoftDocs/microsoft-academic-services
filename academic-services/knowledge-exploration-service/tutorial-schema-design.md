---
title: Build applications with smart filters
description: Step by step tutorial to design MAKES schema for custom data
ms.topic: tutorial
ms.date: 10/15/2020
---

# Build a library application with smart filters

This tutorial is a continuation of the [Link publications with MAKES entities](tutorial-entity-linking.md) tutorial.

This tutorial illustrates how to

- Design a MAKES schema to enable smart filters for library publication entities.
- Build and deploy a custom index for those entities
- Build a filterable publication list client application (as shown below) using MAKES APIs.

![Private Library Application](media/privateLibraryExampleApp-homepage.png)

## Prerequisites

- [Microsoft Academic Knowledge Exploration Service (MAKES) subscription](get-started-setup-provisioning.md) (release version after 2020-11-30)
- Completion of [Link private publication records with MAKES entities](tutorial-entity-linking.md) tutorial
- Read through [How to define index schema](how-to-index-schema.md)
- Download [Schema for linked sample library publications](samplePrivateLibraryData.linked.schema.json)

## Design a schema for linked private library publication

For any MAKES schema design, we need to determine

- What are the input entities and entity attributes to include?
- What are the appropriate data types for each included entity attribute?
- What index operations should each included entity attribute support?

### Input entities

We will be leveraging the linked private library publications from previous tutorial as the input entities for building the custom index. You should have a file named **samplePrivateLibraryData.linked.json** in your working directory from completing the [Link private publication records with MAKES entities](tutorial-entity-linking.md) tutorial. The linked private library publication entities have all the information needed to build the application.

Here's an entity from **samplePrivateLibraryData.linked.json** as example

```json
{
    "OriginalTitle": "Microsoft Academic Graph: When experts are not enough",
    "FullTextUrl": "http://localhost/example-full-text-link-1",
    "Id": 3002924435,
    "logprob": -19.625,
    "DOI": "10.1162/QSS_A_00021",
    "Year": 2020,
    "VenueFullName": "Quantitative Science Studies",
    "CitationCount": 16,
    "EstimatedCitationCount": 16,
    "FieldsOfStudy": [
        {
            "OriginalName": "World Wide Web",
            "Name": "world wide web"
        },
        {
            "OriginalName": "Knowledge graph",
            "Name": "knowledge graph"
        },
        ...
    ],
    "AuthorAffiliations": [
        {
            "Sequence": 1,
            "OriginalAuthorName": "Kuansan Wang",
            "AuthorName": "kuansan wang",
            "OriginalAffiliationName": "Microsoft Research, Redmond, WA, 98052, USA",
            "AffiliationName": "microsoft"
        },
       ...
    ],
    "OriginalAbstract": "An ongoing project explores the extent to which artificial intelligence (AI), specifically in the areas of natural language processing and semantic reasoning, can be exploited to facilitate the stu...",
    "Title": "microsoft academic graph when experts are not enough",
    "TitleWords": [ "microsoft", "academic", "graph", "when", "experts", "are", "not", "enough"],
    "AbstractWords": [ "an", "ongoing", "project", "explores", "the", "extent", "to", "which", "artificial", "intelligence", "ai", "specifically", "in", "areas", "of", "natural", "language", "processing", "and", "semantic", "reasoning", "can", "be", "exploited","facilitate", "stu"]
}
```

For more information on input entity data format, see [Entity data files](how-to-index-data.md).

### Design goal

To determine what entity attributes should be included in the index and what index operation should those attribute have, we have to have a clear design goal. For this tutorial, we are designing a schema that can

1. Show publication information in Publication List Items
    ![The screenshot of a single publication list element](media/privateLibraryExampleApp-publicationCardList.png)

2. Generate filter suggestions in Filter Sections
    ![fields of study filter snapshot](media/privateLibraryExampleApp-filterSectionList.png)

3. Apply filters to the publications
    ![year filter section snapshot](media/privateLibraryExampleApp-filterAction.png)

### Entity attributes, type, and index operations

The design goal above guides us to create the [Schema for linked sample library publications](samplePrivateLibraryData.linked.schema.json), which uses a subset of the entity attributes from the input. The schema can be translated to the following table:

| Attribute Name | Description| Index Data Type | Index Operations |
| ---- | ---- | ---- | ---- |
| `OriginalTitle` | Display only attribute, used in Publication List. | `blob?` | - |
| `OriginalAbstract` | Display only attribute, used in Publication List Item | `blob?` | - |
| `FullTextUrl` | Display only attribute, used in Publication List Item. | `blob?` | - |
| `VenueFullName` | Display only attribute, used in Publication List Item. | `blob?` | - |
| `EstimatedCitationCount` | Display only attribute, used in Publication List Item. | `blob?` | - |
| `Date` | Filter and display attribute, used in Publication List Item and Filter Item | `date?` | `["equals"]` |
| `Year` | Filter and display attribute used in Publication List Item and Filter Item. | `int?` | `["equals"]` |
| `AuthorAffiliations` | Indicates that "AuthorAffiliations" attribute is a object/a composition of multiple attributes | `Composite*` | - |
| `AuthorAffiliations.AffiliationName` | Filter and display attribute used in Publication List Item and Filter Item. | `string?` | `["equals"]` |
| `AuthorAffiliations.AuthorName` | Filter and display attribute used in Publication List Item and Filter Item. | `string?` | `["equals"]` |
| `AuthorAffiliations.OriginalAuthorName` | Display only attribute, used in Publication List Item. | `string?` | `["equals"]` |
| `AuthorAffiliations.Sequence` | Display only attribute, used in Publication List Item. | `blob?` | - |
| `FieldsOfStudy` | Indicates that "FieldsOfStudy" attribute is a object/a composition of multiple attributes | `Composite*` | - |
| `FieldsOfStudy.OriginalName` | Display only attribute, used in Publication List Item. | `blob?` | - |
| `FieldsOfStudy.Name` | Filter and display attribute used in Publication List Item and Filter Item. | `string?` | `["equals"]` |

#### Display only attributes

The display attributes are attributes that are needed for display only, such as `OriginalTitle` and `OriginalAuthorName` in a Publication List Item. We can define them as `blob?` type such that KES can optimize the storage for them.

#### Operational attributes

Operational attributes are attributes that needs to be index so they can be used for performing actions at runtime.

For example, we enable our library application to filter publications by year by adding the `"equals"` operation to the `Year` attribute.

![year filter section snapshot](media/privateLibraryExampleApp-yearFilterSection.png)

We also want to include string attributes as our filter option, such as `FieldsOfStudy.Name`.

![fields of study filter section snapshot](media/privateLibraryExampleApp-fieldsOfStudyFilterSection.png)

Attributes with characteristic that can partition/group the entities well allows MAKES to generate useful filter suggestions for navigating the entities. For example, being able to filter search results by the publication year and fields of study can help users quickly refine the search space.

For attribute values that may be too noisy, you may opt to index the normalized version of the same attribute to improve the filter experience, such as picking `AuthorName` over `OriginalAuthorName` to generate better filter suggestions.

For more information on schema file syntax and supported types/operations, see [Index Schema Files](how-to-index-schema.md).

## Build a custom publication index

Once you're ready with your schema, we can start building a MAKES index for the linked library publications.

Since the index we're building is relatively small and simple, we can build this locally on a x64 Windows machine. If the index you're building contains more than 10,000 entities, use cloud index build to leverage high performing machines in Azure. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)

>[!NOTE]
>Regardless of what you decide to use for production index builds, the best practice is to perform a local index build to validate schema correctness during development to avoid long running failures.

### Validate schema using local index build

1. Copy win-x64 version of kesm.exe to your working directory or include it in your command line PATH variable.

1. Open up a commandline console, change directory to your working directory, and build the index with the following command:

    ```cmd
    kesm.exe BuildIndexLocal --SchemaFilePath samplePrivateLibraryData.linked.schema.json --EntitiesFilePath samplePrivateLibraryData.linked.json --OutputIndexFilePath samplePrivateLibraryData.linked.kes --IndexDescription "Linked Private Library Publications"
    ```

    >[!NOTE]
    > BuildIndexLocal command is only available on win-x64 version of kesm

1. Run Evaluate command to verify the stored entity attributes are correct:

    ```cmd
    kesm Evaluate --IndexFilePaths samplePrivateLibraryData.linked.kes --KesQueryExpression="All()" --Count 1 --Attributes *
    ```

    The output should be

    ```json
    {
      "expr": "All()",
      "entities": [
        {
          "logprob": -17.514,
          "prob": 2.4760901E-08,
          "OriginalTitle": "An Overview of Microsoft Academic Service (MAS) and Applications",
          "OriginalAbstract": "In this paper we describe a new release of a Web scale entity graph that serves as the backbone of Microsoft Academic Service (MAS), a major production effort with a broadened scope to the namesake vertical search engine that has been publicly available since 2008 as a research prototype. At the core of MAS is a heterogeneous entity graph comprised of six types of entities that model the scholarly activities: field of study, author, institution, paper, venue, and event. In addition to obtaining these entities from the publisher feeds as in the previous effort, we in this version include data mining results from the Web index and an in-house knowledge base from Bing, a major commercial search engine. As a result of the Bing integration, the new MAS graph sees significant increase in size, with fresh information streaming in automatically following their discoveries by the search engine. In addition, the rich entity relations included in the knowledge base provide additional signals to disambiguate and enrich the entities within and beyond the academic domain. The number of papers indexed by MAS, for instance, has grown from low tens of millions to 83 million while maintaining an above 95% accuracy based on test data sets derived from academic activities at Microsoft Research. Based on the data set, we demonstrate two scenarios in this work: a knowledge driven, highly interactive dialog that seamlessly combines reactive search and proactive suggestion experience, and a proactive heterogeneous entity recommendation.",
          "FullTextUrl": "http://localhost/example-full-text-link-2",
          "VenueFullName": "The Web Conference",
          "EstimatedCitationCount": "393",
          "Year": 2015,
          "AuthorAffiliations": [
            {
              "AffiliationName": "microsoft",
              "AuthorName": "arnab sinha",
              "OriginalAuthorName": "Arnab Sinha",
              "Sequence": "1"
            },
            {
              "AffiliationName": "microsoft",
              "AuthorName": "zhihong shen",
              "OriginalAuthorName": "Zhihong Shen",
              "Sequence": "2"
            },
           ...
          ],
          "FieldsOfStudy": [
            {
              "OriginalName": "World Wide Web",
              "Name": "world wide web"
            },
            {
              "OriginalName": "Vertical search",
              "Name": "vertical search"
            },
            ...
          ]
        }
      ],
      "timed_out": false
    }
    ```

1. Run Evaluate command to verify index operations are created for specified attributes:

    ```cmd
    kesm Evaluate --IndexFilePaths samplePrivateLibraryData.linked.kes --KesQueryExpression="Year=2020"
    ```

    The output should be

    ```cmd
    {
      "expr": "Year=2020",
      "entities": [
        {
          "logprob": -18.255,
          "prob": 1.18019626E-08
        },
        {
          "logprob": -19.386,
          "prob": 3.8086159E-09
        },
        {
          "logprob": -19.625,
          "prob": 2.9989608E-09
        },
        {
          "logprob": -19.853,
          "prob": 2.3875455E-09
        },
        {
          "logprob": -20.154,
          "prob": 1.7669693E-09
        }
      ],
      "timed_out": false
    }
    ```

### Submit a index job for production workflow

The index we're creating for this tutorial is relatively small and can be built locally. For larger and more complex index(es), use cloud builds to leverage high performing machines in Azure to build. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)

## Deploy a MAKES API with a custom index

We are now ready to set up a MAKES API instance with a custom index.

1. Upload the built, custom index to your MAKES storage account. You can do so by using following [Blob Upload from Azure Portal](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-portal). If you use cloud index build, you may skip this step.

1. Run CreateHostResources to create a MAKES hosting virtual machine image.

    ```cmd
    kesm.exe CreateHostResources --MakesPackage https://<Makes_Storage_Account_Name>.blob.core.windows.net/makes/<Makes_Release_Version> --HostResourceName <Makes_Host_Resource_Name>
    ```

    > [!NOTE]
    > If your account is connected to multiple Azure Directories or Azure Subscriptions, you'll also have to specify the **--AzureActiveDirectoryDomainName** and/or **--AzureSubscriptionId** parameters. See [Command Line Tool Reference](reference-makes-command-line-tool.md#common-azure-authentication-parameters) for more details.

1. Run DeployHost command and use the "--MakesIndex" parameter to load the custom linked private library publication index we've built.

    ```cmd
     kesm.exe DeployHost --HostName "<Makes_Host_Instance_Name>" --MakesPackage "https://<Makes_Storage_Account_Name>.blob.core.windows.net/makes/<Makes_Release_Version>/"  --MakesHostImageId "<Id_From_Previous_Command_Output>" --MakesIndex "<Custom_Index_Url>" --HostMachineSku "Standard_D2_V2"
    ```

    > [!NOTE]
    > Since the index we're hosting is relatively small, you can reduce Azure consumption for the tutorial MAKES host instance by using the "--HostMachineSku" parameter and set the SKU to "Standard_D2_V2".

For more detailed deployment instructions, See [Create API Instances](get-started-create-api-instances.md#create-makes-hosting-resources)

## Create a client application with MAKES APIs

Now that we have a set of backend MAKES APIs to serve our linked library publications. The last step is to create the frontend client to showcase the publication filter capability. In the remaining sections of the tutorial, we will be using the sample UI code to illustrate how to retrieve data and generate filters via Evaluate and Histogram APIs.

### Use sample UI code to see them in action

We've created a sample client app written in javascript along with MAKES. After custom index deployment is complete, you should be able to see the private library example application by visiting:

`<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`

Alternatively, you can download the sample client files listed below and run it locally.

- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.css`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationFieldsOfStudyListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/makesInteractor.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterSectionListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterAttributeListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterablePublicationList.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filter.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/appliedFilterListItem.js`

Modify the `hostUrl` variable in `makesInteractor.js` and point it to your MAKES instance with custom index. You can then and debug the application by launching the application in a browser with `privateLibraryExample.html`

### Crafting a KES query expression to represent publications

We start building our frontend client by crafting a KES query expression to represent the publication list shown on the UI. Since the initial list of publications we want to see is "all publication", we initialize the KES query expression representing the publication list to be `All()`.

This corresponds to the following code in `privateLibraryExample.js`

```javascript
app = new FilterablePublicationList();
app.setOriginalPublicationListExpression("All()");
mount(document.body, app);
```

We will use the **publication list expression** to fetch publication entities in the next step. When filters are applied, we will modify this expression to get the corresponding entities.

For more information on KES Query Expressions, see [Structured query expressions](concepts-query-expressions.md)

### Retrieve top publications

![publication list snapshot](media/privateLibraryExampleApp-publicationCardList.png)

We can call [Evaluate API](reference-post-evaluate.md) with the **publication list expression** to retrieve the top publication entities and transform them into UI elements.

To learn more about how to get publications using Evaluate API, see `MakesInteractor.GetPublications(publicationExpression)` method in `makesInteractor.js`.

After retrieving the publication entities from Evaluate API, all is left to do is to translate the entity data to UI elements. The corresponding data transformation logic for publication UI elements can be found in: `publicationListItem.js` and `publicationFieldsOfStudyListItem.js`

### Generate filter suggestions  

![fields of study filter snapshot](media/privateLibraryExampleApp-filterSectionList.png)

We can call Histogram API with **the publication list expression** to get attribute histograms and transform them into filter suggestions for publications.

[Histogram API](reference-post-histogram.md) returns the most common attribute values weighted by the entity's log probability. For example, execute the following command in your working directory to get the most common `Year` attribute value from the library publications.

  ```cmd
  kesm Histogram --IndexFilePaths samplePrivateLibraryData.linked.kes --KesQueryExpression "All()"  --Attributes "Year" --Count 1
  ```

Histogram API should return 2015 as the most common attribute value for `Year` with a weighted log probability of -17.514

  ```cmd
  {
    "expr": "All()",
    "num_entities": 44,
    "histograms": [
      {
        "attribute": "Year",
        "distinct_values": 16,
        "total_count": 36,
        "histogram": [
          {
            "value": "2015",
            "logprob": -17.5130939835,
            "count": 2
          }
        ]
      }
    ],
    "timed_out": false
  }
  ```

The -17.514 log probability comes from the two publications published in 2015. Execute the following command to see the entity log probability for those publications in 2015:

  ```cmd
  kesm Evaluate --IndexFilePaths samplePrivateLibraryData.linked.kes --KesQueryExpression "Year=2015"  --Attributes "Year"
  ```

  Evaluate API should return the two publications as following

  ```cmd
  {
    "expr": "Year=2015",
    "entities": [
      {
        "logprob": -17.514,
        "prob": 2.4760901E-08,
        "Year": 2015
      },
      {
        "logprob": -24.52,
        "prob": 2.2444E-11,
        "Year": 2015
      }
    ],
    "timed_out": false
  }
  ```

 The -17.514 `Year` attribute histogram log probability comes from adding the two entity log probabilities, `-17.514` and `-24.52` together. `LN(EXP(-17.514) + EXP(-24.52)) = -17.514`

In the context of this tutorial, we can leverage the Histogram API response as **filter suggestions**. To learn more about how to generate filter suggestions using Histogram API, see `MakesInteractor.GetFilters(publicationExpression)` method in `makesInteractor.js`.

The corresponding data transformation logic for filter UI elements can be found in: `filterSectionListItem.js` and in `filterAttributeListItem.js`.

### Apply filters

We can apply filters by modifying the publication list expression. To apply a filter, we create a new expression by combining the current publication expression and the filter expression with a "And" operator. Consider the following scenario as an example:

The publication list expression is initially set to `All()`, showing all publications. To constrain the publications returned to those published in 2019, we apply a publication year filter, with the filter expression being `Year=2019`. The publication list expression will then become `And(All(),Year=2019)`.

If we want to further constraint the publications returned to computer science related only, we apply a fields of study filter, with the filter expression being `Composite(FieldsOfStudy.Name='computer science')`. The publication list expression will then become `And(All(),Year=2019,Composite(FieldsOfStudy.Name='computer science'))`.

For more details see `FilterablePublicationList.appendFilter(attributeName, attributeValue)` and `FilterablePublicationList.updatePublicationList()` method in `filterablePublicationList.js`.

<!-- ## Next steps

Advance to the next section to learn how to add search capability to the library application.

> [!div class="nextstepaction"]
> [Add search to the library application](tutorial-grammar-design.md) -->
