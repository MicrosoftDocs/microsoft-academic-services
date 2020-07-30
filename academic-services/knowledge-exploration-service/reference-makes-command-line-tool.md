---
title: MAKES command line tool reference
description: Documentation for the MAKES command line tool
ms.topic: reference
ms.date: 2020-06-12
---

# MAKES command line tool

Makes command line tool is designed to help users create and host MAKES indexes.

## CreateHostResources Command

Creates the MAKES index hosting resources. E.g. MAKES web host image

```cmd
kesm CreateHostResources --HostResourceName
                         --MakesPackage
                         [--Region]
                         [--MakesWebHost]
```

### CreateHostResources Required Parameters

`--HostResourceName`

The name of the host resource.  

`--MakesPackage`

The base URL to a MAKES release package.

### CreateHostResources Optional Parameters

`--Region`

The region to deploy the host resources to. Defaults to WestUs

`--MakesWebHost`

The URL to MAKES web host zip file that will be used to create the MAKES virtual machine hosting image.

## DeployHost Command

Hosts the specified indexes to power an instance of MAKES API.

```cmd
kesm DeployHost --HostName
                --MakesPackage
                --MakesHostImageId
                [--MakesIndex]
                [--MakesGrammar]
                [--InstanceCount]
                [--Region]
                [--HostMachineSku]
                [--HostMachineDataDiskSizeInGb]
                [--WebHostAppSettingsOverride]
                [--WebHostOverrideUrl]
                [--ApplicationInsightsInstrumentationKey]
                [--LogWebHostRequestsAndResponses]
```

### DeployHost Required Parameters

`--HostName`

The MAKES API host name. API name should be less than 64 characters with only numbers and lower case letters.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesHostImageId`

The MAKES host virtual machine image resource Id. Run CreateHostResource command to generate one.

### DeployHost Optional Parameters

`--MakesIndex`

The MAKES index files URL reference.

`--MakesGrammar`

The MAKES grammar file URL reference.

`--Region`

The region where the MAKES API host should be deployed to.

`--InstanceCount`

The default number of MAKES API host instances (virtual machines).

`--HostMachineSku`

The Sku for MAKES API host machines. Check [Azure Virtual Machine Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes) to get the avaliable options

`--HostMachineDataDiskSizeInGb`

The size of the data disk (Managed Disk:Premium SSD) that the host should have. See [Azure Managed Disks](https://azure.microsoft.com/pricing/details/managed-disks/) for detailed pricing information. If the size is set to 0 (the default), no additional data disk will be attached to the host Virtual Machine and index/grammar data will be stored on the temp drive (D:\\) that comes with the Virtual Machine. If the size is great than 0, then we'll add a managed disk with the specified size, intialize as data disk drive (F:\\) and download the index/grammar data to it. Note: Using data disk instead of the default attached temp drive on the Virtual Machine may lead to decrease performance due to IOPS differences.

`--WebHostAppSettingsOverride`

The application settings used by the web host represented as a list of \"<ApplicationSettingJsonPath>=< ApplicationSettingValue>\" separated by ';'

`--WebHostOverrideUrl`

The host web app package file url reference for overriding default MAKES web host. E.g. https://mymakesstore.blob.core.windows.net/makes/2019-12-26/webhost/my-custom-makes-web-service-host.zip

`--ApplicationInsightsInstrumentationKey`

The Application Insights instrumentation key for sending MAKES web host logs to. E.g. 14f81de7-f9b7-4997-9cd9-d91651fe53df. By default, the logs are only stored on box as windows application events.

`--LogWebHostRequestsAndResponses`

Whether to log every http request that MAKES web host receives.

## CreateIndexResources Command

Creates the MAKES index building resources such as MAKES index build batch account and storage account.

```cmd
kesm CreateIndexResources --IndexResourceName
                          --MakesPackage
                          --MakesIndexResourceConfigFilePath
                          [--Region]
                          [--MakesPreprocessor]
                          [--MakesIndexer]
                          [--MakesJobManager]
```

### CreateIndexResources Required Parameters

`--IndexResourceName`

The name for the indexing resources. Indexing resources name should be less than 64 characters with only numbers and lower case letters.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesIndexResourceConfigFilePath`

Outputs the MAKES indexing resources config file for BuildIndex command. E.g myIndexResConfig.json

### CreateIndexResources Optional Parameters

`--Region`

The region to create the indexing resources in.

`--MakesPreprocessor`

The MAKES preprocessor zip url.

`--MakesIndexer`

The MAKES indexer zip url.

`--MakesJobManager`

The MAKES JobManager zip url.

## BuildIndex Command

Builds MAKES index(es) from json entities.

```cmd
kesm BuildIndex --MakesIndexResourceConfigFilePath
                --EntitiesUrlPrefix
                --OutputUrlPrefix
                [--SynonymResourceFolderUrl]
                [--SchemaUrl]
                [--IndexPartitionCount]
                [--IntersectionCountThresholdForPreCompute]
                [--MakesPreprocessor]
                [--MakesIndexer]
                [--MakesJobManager]
                [--MaxStringLength]
                [--WorkerCount]
                [--WorkerSku]
```

### BuildIndex Required Parameters

`--MakesIndexResourceConfigFilePath`

The MAKES indexing resource configuration file path. Run CreateIndexResource command to generate one.

`--EntitiesUrlPrefix`

The input entities file Url prefix.

`--OutputUrlPrefix`

The output url prefix for writing the built index.

### BuildIndex Optional Parameters
`--SchemaUrl`

The url to the input index schema definition file. By default, the url is set to the schema describing the latest MAKES index release.

`--SynonymResourceFolderUrl`

The url to a resource folder containing all synonym data files required by the input index schema.

`--IndexPartitionCount`

The number of index partitions to create. A index job can finish quicker when there are more partitions; however, the more partitions, the less accurate the interpret results will be. Maximize build performance by creating 1 partition per worker.

`--IntersectionCountThresholdForPreCompute`

The attribute value intersections threshold for pre-computing look up tables. Use this value to tune index build time performance, run time performance, and index size. The higher the value, the smaller index size and slower run-time performance will be. The lower the value, the larger index size and faster run-time performance will be.

`--MaxStringLength`

The maximum string length for all entity attributes. All strings over the maximum string length will be truncated

`--WorkerCount`

The number of virtual machines(workers) used to build the index. Warning, assigning a number larger than IndexPartitionCount won't result in performance gain.

`--WorkerSku`

The virtual machine(worker) sku. Check [Azure Virtual Machine Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes) to get the avaliable options

## BuildIndexLocal Command

Build an index locally using entity data and schema definition files. Can only be run on win-x64 platform.

```cmd
kesm BuildIndex --SchemaFilePath
                --EntitiesFilePath
                --OutputIndexFilePath
                [--IndexDescription]
                [--MaxStringLength]
                [--IntersectionCountThresholdForPreCompute]
```

### BuildIndexLocal Required Parameters

`--SchemaFilePath`

The input schema json file path. E.g. indexSchema.json

`--EntitiesFilePath`

The input entities json file path. E.g. indexEntities.json

`--OutputIndexFilePath`

The output MAKES index binary file path. E.g. index.kes

### BuildIndexLocal Optional Parameters

`--IndexDescription`

A description to include in the index. E.g. My custom MAKES index build.

`--MaxStringLength`

The maximum string length for all entity attributes. All strings over the maximum string length will be truncated

`--IntersectionCountThresholdForPreCompute`

The attribute value intersections threshold for pre-computing look up tables. Use this value to tune index build time performance, run time performance, and index size. The higher the value, the smaller index size and slower run-time performance will be. The lower the value, the larger index size and faster run-time performance will be.

## CompileGrammarLocal Command

Compiles a grammar definition xml file into compiled grammar file.

```cmd
kesm CompileGrammarLocal --GrammarDefinitionFilePath
                         --OutputCompiledGrammarFilePath
```

### CompileGrammarLocal Required Parameters

`--GrammarDefinitionFilePath`

The input grammar definition xml file path. E.g. grammar.xml

`--OutputCompiledGrammarFilePath`

The output compiled grammar binary file path. E.g. grammar.kesg

## DescribeIndex Command

Retrieves the description, schema, build time and number of entities for the index binary.

```cmd
kesm DescribeIndex --IndexFilePath
```

### DescribeIndex Required Parameters

`--IndexFilePath`

The file path to the index binary. E.g. index.kes

## DescribeGrammar Command

Retrieves original grammar definition XML from the compiled grammar binary

```cmd
kesm DescribeGrammar --CompiledGrammarFilePath
```

### DescribeGrammar Required Parameters

`--CompiledGrammarFilePath`

The file path to the compiled grammar binary. E.g. grammar.kesg

## Interpret Command

Interprets a natural language query using specified indexes and grammar.

```cmd
kesm Interpret --Query
               --IndexFilePaths
               --GrammarFilePath
               [--NormalizeQuery]
               [--AllowCompletions]
               [--Offset]
               [--Count]
               [--InterpretationEntityAttributes]
               [--InterpretationEntityCount]
               [--Timeout]
```

### Interpret Required Parameters

`--Query`

The natural lanugage query string to interpret.

`--IndexFilePaths`

The file path expression for specifying which index file(s) to use. Use wild card to specify multiple indexes e.g. './index.*.kes'.

`--GrammarFilePath`

The compiled grammar binary file path. Interpret requires a compiled grammar binary

### Interpret Optional Parameters

`--NormalizeQuery`

Whether normalization rules should be applied to the query before making interpretations.

`--AllowCompletions`

Whether to generate interpretations assuming the query is a partial query that's not yet fully formulated. When set to true, better interpretations can be generated for scenarios such as auto-suggest. 

`--Offset`

The number of top interpretations to be skipped/excluded in the result set.

`--Count`

The number of top interpretations to be included in the result set.

`--SelectInterpretationEntities`

A list of entity attributes, seperated by ','. Use '*' for all entity attributes. Each interpretation in the result set can include the top matching entities used for generating the interpretation. SelectInterpretationEntities specifies which attributes of the top matching entities should be included in the result set.

`--TakeInterpretionEntities`

The number of top matching entities to be included for each interpretation. Each interpretation in the result set can include the top matching entities used for generating the interpretation. TakeInterpretionEntities specifies how many top matching entnties should be included in the result set

`--Timeout`

Maximum amount of time in milliseconds allowed for command to complete before aborting the command. The interpret command will return the top interptations found in the allowed timedout.

## Evaluate Command

Evaluates a KES query expression and returns the top matching entities in the index(es).

```cmd
kesm Evaluate --KesQueryExpression
              --IndexFilePaths
              [--Attributes]
              [--Skip]
              [--Take]
              [--OrderBy]
              [--OrderByDescending]
              [--Timeout]
```

### Evaluate Required Parameters

`--KesQueryExpression`

The KES query expression that specifies entities in the index(es).

`--IndexFilePaths`

The file path expression for specifying which index file(s) to use. Use wild card to specify multiple indexes e.g. './index.*.kes'

### Evaluate Optional Parameters

`--Attributes`

A list of entity attributes to be included in the result set, seperated by ','. Use '*' for all attributes.

`--Offset`

The number of top entities to be skipped/excluded in the result set.

`--Count`

The number of top interpretations to be included in the result set.

`--OrderBy`

Name of the entity attribute to use for sorting/ordering the entities in the result set. By default, entities are sorted by descending entity weight (static rank).

`--OrderByDescending`

The direction for sorting entities. By default, entities are sorted by descending entity weight (static rank).

`--Timeout`

Maximum amount of time in milliseconds allowed for the command to complete before aborting the command. Use 0 to disable timeout.

## Histogram Command

Calculates distinct/total entity attribute counts and top attribute values for entities specified by a KES query expression.

```cmd
kesm Histogram --KesQueryExpression
               --IndexFilePaths
               [--Attributes]
               [--Skip]
               [--Take]
               [--OrderBy]
               [--OrderByDescending]
               [--Timeout]
```

### Histogram Required Parameters

`--KesQuery`

The KES query expression that specifies entities in the index(es).

`--IndexFilePaths`

The file path expression for specifying which index file(s) to use. Use wild card to specify multiple indexes e.g. './index.*.kes' Histogram requires at least one index.

### Histogram Optional Parameters

`--Attributes`

A list of entity attributes, seperated by ','. Use '*' for all attributes. Histogram will generate total count, distinct count, and top values for the select attributes for entities specified in the KesQueryExpression.

`--Offset`

The number of top entity attribute values to be skipped/excluded in the result set.

`--Count`

The number of top entity attribute values to be included in the result set.

`--SampleSize`

The maxium number of entities to consider for generating histogram. If this number is smaller than the number of entities in index(es), the histogram will be generated based on the top entities specified by the number. If this number is 0, all entities specified by the KES query will be used.

`--Timeout`

Maximum amount of time in milliseconds allowed for the command to complete before aborting the command. Use 0 to disable timeout.

## Common Command Parameters

Below are common parameters that can be applied to more than one commands.

### Common Azure Authentication Parameters

Applies to all commands. MAKES command line tool leverages device login to access Azure Subscriptions by default. You can specify AzureActiveDirectoryDomainName, AzureSubscriptionId, and AzureCredentialsFilePath parameter to change the authentication behavior.

`--AzureActiveDirectoryDomainName`

The azure active directory domain name associated with the Azure Subscription that user would like to use to execute the command. (e.g. "constco.onmicrosoft.com"). This is not required if the user's azure account is linked to only one Azure Active Directory.

`--AzureSubscriptionId`
The Azure Subscription Id associated with the Azure Subscription that user would ike to use to execute the command. This only required if the user wants to use an Azure Subscription that's not being set as the default Azure Subscription for the account.

You can find this information by logging into Azure Management Portal and go to your Azure Active Directory resource detail page.

`--AzureCredentialsFilePath`

The path to the azure credential file to use for authentication. If you're using the command line tool frequently or want to automate. You can generated an Azure credential file to avoid inputting your azure credentials each time you run an command.

You can generate this file using [Azure CLI 2.0](https://github.com/Azure/azure-cli) through the following command. Make sure you selected your subscription by `az account set --subscription <name or id>` and you have the privileges to create service principals.

```bash
az ad sp create-for-rbac --sdk-auth > my.azureauth
```

If you don't have Azure CLI installed, you can also do this in the [cloud shell](https://docs.microsoft.com/azure/cloud-shell/quickstart).

### Common Azure Resource Group Parameter

Applies to Azure resource creation commands (CreateHostResources, CreateIndexResources, and DeployHost.) MAKES command line tool may create Azure resources for the user. You can use the common resource group parameter to ensure the resources created will be in the specified group.

`--ResourceGroupName`
The name of the resource group to deploy the Azure resources to. If the resource group does not exist, a new resource group will be created using the name specified. If new resource group creation is needed, the location of the new resource group will be the same as the `--Region` specified for the command.
