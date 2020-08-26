# Introduction 

This is the first part of building an knowledge application for KDD conference. 

This app will have all the knowledge of papers published in **Interationial Conference on Knowlege Discovery and Data Mining**. 

The application will help users find KDD papers and Oral presentations through Natural Language Processing and smart fitlers. 

In this tutorial, we'll focus on designing the approrpiate KES schema such that KDD papers can be retriable and filterable. You will start by designing a KES schema for the conference papers, build/host the index, and leverage MAKES REST API to create the Filterable Paper List UI.


## Get started 

Download tutorial resources from [here](https://makesstore.blob.core.windows.net/makes-tutorial-resource/latest.zip).

Download MAKES managment tool (kesm.exe) from your latest MAKES release 

## Design a KES schema

We start by determining what attributes do we want to include in the index, what are appropriate types to store them, and what operations should they support. The conference paper entity data **kddData.json** can be found at in the tutorial resource folder. The data is dervieved from MAG.

### Display only attributes

The display attrbitues are attributes that are needed for display only, such as **OriginalTitle**, **OriginalAuthorName** In this case, we can define them as **Blob** type such that KES won't create any index for them.

### Filter attributes

Filter attributes are attributes that can be used to filter entity data.

The numeric attributes that we want to filter by would be the conference paper's **Year, CitationCount, EstimatedCitationCount**. Depending on the filter UX we want to provide, we can add **equals** and/or **is_between** operations to the filterable numeric attributes. 

>
>
>[!NOTE] 
>Try adding **is_between** to numeric filter attributes and extend the sample code to enables publication year range filter.

[screen-shot-schema-numeric-fields-index-operations]()
 
For string attributes, we want to select attributes that common values such as journal name, conference name. For attribute values that may be too noisy, you may opt for the normalized version such as using **AuthorName** instead of **OriginalAuthorName**. we should add **equals** operation to these attributes.

[screen-shot-schema-string-fields-index-operations]()

## Build a custom paper index 

Once you're ready with your schema. We can start building the index. Since the index we're building is relatively small, we can build this locally on a windows machine. If the index you're building is large, you can use cloud index build to leverage high performing machines in Azure.  Nevertheless, we should use local index build with test data to validate the schema correctness during development.

### Validate schema using local index build

Open up a commandline console, change directory to the root of the conference tutorial resource folder, and build the index with the following command:

```cmd
kesm.exe BuildIndexLocal --SchemaFilePath KddSchema.json --EntitiesFilePath kddData.json --OutputIndexFilePath kddpapers.kes --IndexDescription "Papers from KDD conference"
```

>![NOTE]
> BuildIndexLocal command is only avaliable on win-x64 version of kesm
>

Validate the index is built correctly by inspecting the index meta data by using the following command:

```cmd
kesm.exe DescribeIndex --IndexFilePath kddpapers.kes
```

![snap-shot-describe-index-cmd-output](media/snap-shot-describe-index-cmd-output.png)

### Submit a index job for production workflow

The index we're creating for this tutorial is relatively small and can be built locally. For larger size index, we can use cloud builds to leverage high performing machines in Azure to build. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)


## Deploy MAKES API Host with custom index

We are now ready to set up a MAKES API instance with custom index. Upload your custom index to your MAKES storage account. If you use cloud indx build, you may skip this step. 

Run CreateHostResources to create MAKES hosting virtual machine image.

```cmd
kesm.exe CreateHostResources --MakesPackage https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version> --HostResourceName <makes_host_resource_name>
```

Run DeployHost command and use the "--MakesIndex" parameter to load the custom KDD paper index we've built.

```cmd
 kesm.exe DeployHost --HostName "<makes_host_instance_name>" --MakesPackage "https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version>/"  --MakesHostImageId "<id_from_previous_command_output>" --MakesIndex "<custom_index_url>"
```

>
> ![NOTE]
> For more detailed deployment instruction, see (Create API Instances)[get-started-create-api-instances.md#create-makes-hosting-resources]

## Create Filterable Paper List UX using Evaluate and Histogram API

We now have a backend API to server our conference paper data. We can now create a client app to showcase the filterable paper list. 

### Paper list KES Query Expression

We start with crafting a KES query expression that will represent the paper list. Since the inital list of papers we want to see is "all papers", the corresponding KES query expression would be "All()"

### Retrieve top papers 

We can then call Evaluate API with the paper list expression "All()" to retrieve all the paper entities. After retrieiving the paper entities from Evaluate API, all is left is to translate the entity data to UI elements. See **async GetPapers(paperExpression)** method in **<tutorial_resource_root>/ConferenceWebsite/makesInteractor.js** for more details.

### Generate filters  

We can also call Histogram API with the paper list expression "All()" to get filter attribute histograms and transform them into filters. 

Histogram returns the most probalistic attribute values for each attributes. We can use these values for each filter attribute as suggested filter values. See **async GetFilters(paperExpression)** method in **<tutorial_resource_root>/ConferenceWebsite/makesInteractor.js** for more details.

### Handle filter event

We can apply filter by modifying the paper list expression. To apply a filter, we combine the current paper expression and the target filter expression with a "And" operator. 

For example, to apply a filter to constraint the paper publication year to 2013, the filter expression will be **Y=2019**, and the paper list expession will be **And(All(),Y=2019)**.

See **async updatePaperList()** method in **<tutorial_resource_root>/ConferenceWebsite/filterablePaperList.js** for more details.

For more information on KES Query Expressions, see [Structured query expressions](concepts-query-expressions.md)

### Use sample UI code to see them in action

We've create a sample client app written in javascript. You should be able to see the conference website with filterable paper list by wiring up the MAKES host URL to your deployed MAKES instance. For more to run the client app information, see **<tutorial_resource_root>/ConferenceWebsite/README.md**