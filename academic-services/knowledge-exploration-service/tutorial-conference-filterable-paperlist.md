---
title: Create a filterable paper list using MAKES 
description: Step by step tutorial for creating a filterable paper list using MAKES
ms.topic: tutorial
ms.date: 09/18/2020
---

# Create a filterable paper list using MAKES

This is the first part of building an knowledge application for KDD conference. 

The application will have all the knowledge of papers published in **Internationial Conference on Knowledge Discovery and Data Mining**. It will help users find KDD papers and Oral presentations through Natural Language Processing and smart filters.

In this tutorial, we'll focus on designing the appropriate KES schema such that KDD papers can be retrievable and filterable. We will start by designing a KES schema for the conference papers, build/host the index, and leverage the MAKES REST APIs (Evaluate and Histogram) to create the Filterable Paper List UI.

## Prerequisites

- [Microsoft Academic Knowledge Service (MAKES) subscription](get-started-setup-provisioning.md)

## Download and unzip tutorial resources

1. Download and unzip the MAKES management tool (kesm.exe) from your latest MAKES release.
    (You can find this in your MAKES storage account under:
    **https://<makes_storage_account>.blob.core.windows.net/makes/<makes_release>/tools/kesm.zip**)

1. Download and unzip tutorial resources from [here](TutorialResources.zip).

## Design a KES schema for KDD data

We start by determining what attributes to include in the index, what are the appropriate types to store the attributes, and what operations should the attributes support. In this tutorial, we provided sample KDD data derived from MAG. The conference paper entity data can be found in **<tutorial_resource_root>/kddData.json**.

Here's an example entity from **kddData.json**

```json
{
    "logprob": -21.407,
    "Id": 20513064,
    "Title": "proceedings of the 4th multiclust workshop on multiple clusterings multi view data and multi source knowledge driven clustering",
    "TitleWords": ["proceedings", "of", "the", "4th", "multiclust", "workshop", "on", "multiple", "clusterings", "multi", "view", "data", "and", "source", "knowledge", "driven", "clustering"],
    "OriginalTitle": "Proceedings of the 4th MultiClust Workshop on Multiple Clusterings, Multi-view Data, and Multi-source Knowledge-driven Clustering",
    "Abstract": "Cluster detection is a very traditional data analysis task with several decades of research. However, it also includes a large variety of different subtopics investigated by different communities such as data mining, machine learning, statistics, and database systems. \"Multiple Clusterings, Multi-view Data, and Multi-source Knowledge-driven Clustering\" names several challenges around clustering: making sense or even making use of many, possibly redundant clustering results, of different representations and properties of data, of different sources of knowledge. Approaches such as ensemble clustering, semi-supervised clustering, subspace clustering meet around these problems. Yet they tackle these problems with different backgrounds, focus on different details, and include ideas from different research communities. This diversity is a major potential for this emerging field and should be highlighted by this workshop. A core motivation for this workshop series is our believe that these approaches are not just tackling different parts of the problem but that they should benefit from each other and, ultimately, combine the different perspectives and techniques to tackle the clustering problem more effectively. In paper presentations and discussions, we therefore would like to encourage the workshop participants to look at their own research problems from multiple perspectives.",
    "Year": 2013,
    "Date": "2013-08-11",
    "CitationCount": 1,
    "EstimatedCitationCount": 1,
    "FieldsOfStudy": [
        {
            "Name": "subspace clustering",
            "OriginalName": "Subspace clustering"
        },
        {
            "Name": "multi source",
            "OriginalName": "Multi-source"
        },
        {
            "Name": "data science",
            "OriginalName": "Data science"
        },
        {
            "Name": "conceptual clustering",
            "OriginalName": "Conceptual clustering"
        },
        {
            "Name": "computer science",
            "OriginalName": "Computer science"
        },
        {
            "Name": "cluster analysis",
            "OriginalName": "Cluster analysis"
        }
    ],
    "AbstractWords": ["cluster", "detection", "is", "a", "very", "traditional", "data", "analysis", "task", "with", "several", "decades", "of", "research", "however", "it", "also", "includes", "large", "variety", "different", "subtopics", "investigated", "by", "communities", "such", "as", "mining", "machine", "learning", "statistics", "and", "database", "systems", "38", "39", "40", "41", "43", "44", "names", "challenges", "around", "clustering", "making", "sense", "or", "even", "use", "many", "possibly", "redundant", "results", "representations", "properties", "sources", "knowledge", "approaches", "ensemble", "semi", "supervised", "subspace", "meet", "these", "problems", "yet", "they", "tackle", "backgrounds", "focus", "on", "details", "include", "ideas", "from", "this", "diversity", "major", "potential", "for", "emerging", "field", "should", "be", "highlighted", "workshop", "core", "motivation", "series", "our", "believe", "that", "are", "not", "just", "tackling", "parts", "the", "problem", "but", "benefit", "each", "other", "ultimately", "combine", "perspectives", "techniques", "to", "more", "effectively", "in", "paper", "presentations", "discussions", "we", "therefore", "would", "like", "encourage", "participants", "look", "at", "their", "own", "multiple"],
    "Conference": { "Name": "kdd"},
    "VenueFullName": "Knowledge Discovery and Data Mining",
    "VenueShortName": "KDD",
    "AuthorAffiliations": [
        {
            "AuthorName": "ira assent",
            "OriginalAuthorName": "Ira Assent",
            "Sequence": 1,
            "AffiliationName": "aarhus university",
            "OriginalAffiliationName": "aarhus university, denmark"
        },
        {
            "AuthorName": "carlotta domeniconi",
            "OriginalAuthorName": "Carlotta Domeniconi",
            "Sequence": 2,
            "AffiliationName": "george mason university",
            "OriginalAffiliationName": "George Mason University"
        },
        {
            "AuthorName": "francesco gullo",
            "OriginalAuthorName": "Francesco Gullo",
            "Sequence": 3,
            "AffiliationName": "yahoo",
            "OriginalAffiliationName": "Yahoo! Res., Spain"
        },
        {
            "AuthorName": "andrea tagarelli",
            "OriginalAuthorName": "Andrea Tagarelli",
            "Sequence": 4,
            "AffiliationName": "university of calabria",
            "OriginalAffiliationName": "[University of Calabria, Italy]"
        },
        {
            "AuthorName": "arthur zimek",
            "OriginalAuthorName": "Arthur Zimek",
            "Sequence": 5,
            "AffiliationName": "ludwig maximilian university of munich",
            "OriginalAffiliationName": "Ludwig Maximilians Universit�t M�nchen Germany"
        }
    ]
}
```

After inspecting the data, we can now create the schema for it.

### Display only attributes

The display attrbitues are attributes that are needed for display only, such as **OriginalTitle**, **OriginalAuthorName** In this case, we can define them as **Blob** type such that KES won't create any index for them.

The following schema elements reflect the display attributes:

```json
{
  "attributes": [
    {"name": "OriginalTitle","type": "blob?"},
    {"name": "Abstract","type": "blob?"},

    {"name": "AuthorAffiliations","type": "Composite*"},
    {"name": "AuthorAffiliations.OriginalAuthorName","type": "blob?"},
    {"name": "AuthorAffiliations.OriginalAffiliationName","type": "blob?"},

    {"name": "FieldsOfStudy","type": "Composite*"},
    {"name": "FieldsOfStudy.OriginalName","type": "blob?"},

    {"name": "VenueFullName","type": "blob?"},
    {"name": "VenueShortName","type": "blob?"}
  ]
}
```

### Filter attributes

Filter attributes are attributes that can be used to filter entity data.

The numeric attributes that we want to filter by would be the conference paper's **Year, CitationCount, EstimatedCitationCount**. Depending on the filter UX we want to provide, we can add **equals** and/or **is_between** operations to the filterable numeric attributes.

>[!NOTE]
>Try adding **is_between** to numeric filter attributes and extend the sample code to enables publication year range filter.

The following schema elements reflect the filterable numeric attributes:

```json
{
  "attributes": [
    {"name": "Id","type": "int64!","operations": [ "equals" ]},
    {"name": "Year","type": "int32?","operations": [ "equals", "is_between" ]},
    {"name": "CitationCount","type": "int32?","operations": [ "equals", "is_between" ]},
    {"name": "EstimatedCitationCount","type": "int32?","operations": [ "equals", "is_between" ]},
    {"name": "AuthorAffiliations.Sequence","type": "int32?","operations": [ "equals" ]}
  ]
}
```

For string attributes, we want to select attributes that have common values such as journal name, conference name. For attribute values that may be too noisy, you may opt for the normalized version such as using **AuthorName** instead of **OriginalAuthorName**. We should add **equals** operation to these attributes.

The following schema elements reflect the filterable string attributes:

```json
{
  "attributes": [
    {"name": "DOI","type": "string?","operations": [ "equals", "starts_with" ]},
    {"name": "Title","type": "string?","operations": [ "equals", "starts_with" ]},
    {"name": "TitleWords","type": "string*","operations": [ "equals" ]},
    {"name": "AbstractWords","type": "string*", "operations": [ "equals" ]},
  
    {"name": "AuthorAffiliations","type": "Composite*"},
    {"name": "AuthorAffiliations.AuthorName","type": "string?","operations": [ "equals", "starts_with" ]},
    {"name": "AuthorAffiliations.AffiliationName","type": "string?","operations": [ "equals", "starts_with" ]},

    {"name": "FieldsOfStudy","type": "Composite*"},
    {"name": "FieldsOfStudy.Name","type": "string?","operations": [ "equals", "starts_with" ]},

    {"name": "Conference","type": "Composite?"},
    {"name": "Conference.Name","type": "string?","operations": [ "equals", "starts_with" ]},
  ]
}
```

We've include a complete schema for you to compare against. See **<tutorial_resource_root>/kddSchema.josn** for the complete schema.

## Build a custom paper index

Once you're ready with your schema. We can start building a MAKES index for the KDD data.

Since the index we're building is relatively small and simple, we can build this locally on a dev machine. If the index you're building is large or contains more complex operations, use cloud index build to leverage high performing machines in Azure. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)

>[!NOTE]
>Regardless of what you decide to use for production index builds, the best practice is to perform a local index build to validate schema correctness during development to avoid long running failures.

### Validate schema using local index build

1. Copy win-x64 version of kesm.exe to **<tutorial_resource_root>\kesm.exe** or include it in your command line PATH variable. 

1. Open up a commandline console, change directory to the root of the conference tutorial resource folder, and build the index with the following command:

    ```cmd
    kesm.exe BuildIndexLocal --SchemaFilePath <tutorial_resource_root>/kddSchema.json --EntitiesFilePath kddData.json --OutputIndexFilePath <tutorial_resource_root>/kddpapers.kes --IndexDescription "Papers from KDD conference"
    ```

>[!NOTE]
> BuildIndexLocal command is only avaliable on win-x64 version of kesm


Validate the index is built according to schema by inspecting the index meta data using the following command:

```cmd
kesm.exe DescribeIndex --IndexFilePath <tutorial_resource_root>/kddpapers.kes
```

![describe index command output](media/snap-shot-describe-index-cmd-output.png)

### Submit a index job for production workflow

The index we're creating for this tutorial is relatively small and can be built locally. For larger and more complex index, use cloud builds to leverage high performing machines in Azure to build. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)

## Deploy MAKES API Host with a custom index

We are now ready to set up a MAKES API instance with a custom index.

1. Upload the built, custom index to your MAKES storage account. You can do so by using following [Blob Upload from Azure Portal](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-portal). If you use cloud index build, you may skip this step.

1. Run CreateHostResources to create a MAKES hosting virtual machine image.

    ```cmd
    kesm.exe CreateHostResources --MakesPackage https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version> --HostResourceName <makes_host_resource_name>
    ```

> [!NOTE]
> If your account is connected to multiple Azure Directories or Azure Subscriptions, you'll also have to specify the **--AzureActiveDirectoryDomainName** and/or **--AzureSubscriptionId** parameters. See [Command Line Tool Reference](reference-makes-command-line-tool.md#common-azure-authentication-parameters) for more details.

1. Run DeployHost command and use the "--MakesIndex" parameter to load the custom KDD paper index we've built.

    ```cmd
     kesm.exe DeployHost --HostName "<makes_host_instance_name>" --MakesPackage "https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version>/"  --MakesHostImageId "<id_from_previous_command_output>" --MakesIndex "<custom_index_url>"
    ```

For more detailed deployment instructions, See [Create API Instances](get-started-create-api-instances.md#create-makes-hosting-resources)

> [!NOTE]
> Since the index we're hosting is relatively small, you can reduce Azure consumption for the tutorial MAKES host instance by using the "--HostMachineSku" parameter and set the SKU to "Standard_D2_V2".

## Create Client Application with MAKES REST APIs

We now have a backend API to serve our conference paper data. The last step is to create the client application to showcase the filterable paper list. The client application will retrieve data and generate filters via Evaluate and Histogram APIs.

### Paper list KES Query Expression

We start building our client by crafting a KES query expression to represent the paper list shown on the UI. Since the initial list of papers we want to see is "all papers", the corresponding KES query expression would be "**All()**".

This corresponds to the following code in **<tutorial_resource_root>/ConferenceApp_FilterablePaper/index.js**

```javascript
/*
 * Client app entry point/ main.
 */
var app = new FilterablePaperList();
app.setOriginalPaperListExpression("All()");
mount(document.body, app);
```

We will use this expression to fetch paper data in the next step. When filters are applied, we will modify this expression to get the corresponding data.

For more information on KES Query Expressions, see [Structured query expressions](concepts-query-expressions.md)

### Retrieve top papers

We can call Evaluate API with the paper list expression ( Initially set to "**All()**" ) to retrieve paper entities for display.

To get papers using Evaluate API, see **MakesInteractor.GetPapers(paperExpression)** method in **<tutorial_resource_root>/ConferenceApp_FilterablePaper/makesInteractor.js**:

```javascript
/*
* Gets a list of papers using a KES expression
*/
async GetPapers(paperExpression)
{
    let requestBody = {
            expr: paperExpression,
            attributes: this.paperListItemAttributes,
            count: this.paperListItemCount
        }

    let response = await Promise.resolve($.post(this.GetEvaluateApiEndpoint(), requestBody));
    return response?.entities;
}
```

For more information on Evaluate API, see [Evaluate REST API](reference-post-evaluate.md)

 After retrieving the paper entities from Evaluate API, all is left to do is to translate the entity data to UI elements. The corresponding data transformation logic for paper UI elements can be found in:

- **<tutorial_resource_root>/ConferenceApp_FilterablePaper/paperListItem.js**
- **<tutorial_resource_root>/ConferenceApp_FilterablePaper/paperFieldsOfStudyListItem.js**

### Generate filters  

We can also call Histogram API with the paper list expression to get filter attribute histograms and transform them into filters.

Histogram returns the most probabilistic attribute values for each attributes. We can use these values for each filter attribute as suggested filter values.

To generate filters using Histogram API, see **MakesInteractor.GetFilters(paperExpression)** method in **<tutorial_resource_root>/ConferenceApp_FilterablePaper/makesInteractor.js**:

```javascript
    /*
     * Gets a list of filters/filter sections using a KES expression
     */
    async GetFilters(paperExpression)
    {
        let requestBody = {
            expr: paperExpression,
            attributes: this.paperFilterAttributes,
            count: this.paperFilterCount
        }
        let response = await Promise.resolve($.post(this.GetHistogramApiEndpoint(), requestBody));
        return response?.histograms;
    }
```

For more information on Histogram API, see [Histogram REST API](reference-post-histogram.md)

The corresponding data transformation logic for filter UI elements can be found in:

- **<tutorial_resource_root>/ConferenceApp_FilterablePaper/filterSectionListItem.js**
- **<tutorial_resource_root>/ConferenceApp_FilterablePaper/filterAttributeListItem.js**

### Handle filter events

We can apply filters by modifying the paper list expression. To apply a filter, we combine the current paper expression and the target filter expression with a "And" operator.

For example, with a *initial paper expression** being **All()**, to apply a publication year filter to constrain the publications returned to those published in 2019, the *filter expression* will be **Y=2019**, and the final paper list expression will become **And(All(),Y=2019)**.

To handle filter events, see **FilterablePaperList.appendFilter(attributeName, attributeValue)** and **FilterablePaperList.updatePaperList()** method in **<tutorial_resource_root>/ConferenceApp_FilterablePaper/filterablePaperList.js** for more details.

```javascript
    /*
     * appends a filter and refreshes the paper list.
     */
    async appendFilter(attributeName, attributeValue)
    {
        if (!attributeName)
        {
            console.log("appendFilter: attributeName cannot be null");
            return;
        }
        if (!attributeValue)
        {
            console.log("appendFilter: attributeValue cannot be null");
            return;
        }

        this.pageData.appliedFilterListData.push(new Filter(attributeName, attributeValue));
        await this.updatePaperList();
    }

    /*
     * refreshes the paper list.
     * updates the paper list expression by combing the original paper list expression and applied filters expressions
     */
    async updatePaperList()
    {
        let filterExpressions = this.pageData.appliedFilterListData.map( paperFilter => paperFilter.getKesExpression())
        filterExpressions.push(this.pageData.originalExpression);
        let paperExpression = this.makesInteractor.CreateAndExpression(filterExpressions);
        await this.updatePaperListExpression(paperExpression);
    }
```

### Use sample UI code to see them in action

We've created a sample client app written in javascript. You should be able to see the conference application with a filterable paper list by wiring up the MAKES host URL to your deployed MAKES instance. For more to run the client app information, see **<tutorial_resource_root>/ConferenceApp_FilterablePaper/README.md**