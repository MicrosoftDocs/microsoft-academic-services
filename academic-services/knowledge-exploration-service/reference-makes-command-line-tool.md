---
title: MAKES command line tool reference
description: Documentation for the MAKES command line tool
ms.topic: reference
ms.date: 2020-02-10
---

# MAKES command line tool

Makes command line tool is designed to help users create and host MAKES indexes.

## CreateHostResources command

Creates the MAKES index hosting resources. E.g. MAKES web host image

```cmd
kesm CreateHostResources --HostResourceName
            --MakesPackage
            --[Region]
            --[MakesWebHost]
```

### Required parameters

`--HostResourceName`

The name of the host resource.  

`--MakesPackage`

The base URL to a MAKES release package.

### Optional parameters

`--Region`

The region to deploy the host resources to. Defaults to WestUs

`--MakesWebHost`

The URL to MAKES web host zip file that will be used to create the MAKES virtual machine hosting image.

## DeployHost command

Hosts the specified indexes to power an instance of MAKES API.

```cmd
kesm DeployHost --HostName
                --MakesPackage
                --MakesHostImageId
                --[MakesIndex]
                --[MakesGrammar]
                --[Instances]
                --[HostMachineSku]
                --[Region]
                --[KeepResourcesOnFailure]
```

### Required parameters

`--HostName`

The MAKES API host name. API name should be less than 64 characters with only numbers and lower case letters.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesHostImageId`

The MAKES host virtual machine image resource Id. Run CreateHostResource command to generate one.

### Optional parameters

`--MakesIndex`

The MAKES index files URL reference.

`--MakesGrammar`

The MAKES grammar file URL reference.

`--Region`

The region where the MAKES API host should be deployed to.

`--Instances`

The default number of MAKES API host instances.

`--HostMachineSku`

The sku for MAKES API host machines.

`--KeepResourcesOnFailure`

Whether to clean up resources if deployment failed for any reason. Used for debugging MAKES host deployment failures.

## CreateIndexResources Command

Creates the MAKES index building resources. E.g. MAKES index build batch account, storage account.

```cmd
kesm CreateIndexResources --IndexResourceName
                        --MakesPackage
                        --MakesIndexResourceConfigFilePath
                        --[Region]
                        --[MakesPreprocessor]
                        --[MakesIndexer]
                        --[MakesJobManager]
```

### Required Parameters

`--IndexResourceName`

The name for the indexing resources. Indexing resources name should be less than 64 characters with only numbers and lower case letters.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesIndexResourceConfigFilePath`

Outputs the MAKES indexing resources config file for BuildIndex command. The command won't write a config file unless a path is provided.

### Optional Parameters

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
kesm BuildIndex --MakesIndexBuildResourceConfigFilePath
                --EntitiesUrlPrefix
                --OutputUrlPrefix
                --[IndexPartitionCount]
                --[IntersectionMinCount]
                --[MakesPreprocessor]
                --[MakesIndexer]
                --[MakesJobManager]
                --[MaxStringLength]
                --[RemoveEmptyValues]
                --[WorkerCount]
                --[WorkerMachineSku]
```

### Required Parameters

`--MakesIndexBuildResourceConfigFilePath`

The MAKES indexing resource configuration file path. Run CreateIndexResource command to generate one.

`--EntitiesUrlPrefix`

The input entities file Url prefix.

`--OutputUrlPrefix`

The output url prefix for writing the built index.

### Optional Parameters

`--IndexPartitionCount`

The number of index partitions to create. A index job can finish quicker when there are more partitions; however, the more partitions, the less accurate the interpret results will be. Maximize build performance by creating 1 partition per worker.

`--IntersectionMinCount`

The minimum intersections between indexed attribute for which the indexer should generate pre-calculated results. The higher the count, the more process will be required at run time. The lower the count, the larger the generated index will be.

`--MaxStringLength`

The maximum string length for string type attributes.

`--RemoveEmptyValues`

Whether to remove empty attribute values to reduce index size.

`--WorkerCount`

The number of virtual machines(workers) used to build the index. Warning, assigning a number larger than IndexPartitionCount won't result in performance gain.

`--WorkerMachineSku`

The virtual machine(worker) sku. Use https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines/listavailablesizes to get the most recent options

## Common authentication parameters

MAKES command line tool leverages device login to access azure subscriptions by default. You can specify AzureActiveDirectoryDomainName and AzureCredentialsFilePath parameter to change the authentication behavior.

### AzureActiveDirectoryDomainName

The azure active directory domain name associated with the azure subscription that user would like to use to execute the command. (e.g. "constco.onmicrosoft.com"). This is not required if the user's azure account has only one azure subscription.

You can find this information by logging into azure portal and go to your Azure Active Directory resource detail page.

### AzureCredentialsFilePath

The path to the azure credential file to use for authentication. If you're using the command line tool frequently or want to automate. You can generated an Azure credential file to avoid inputting your azure credentials each time you run an command.

You can generate this file using [Azure CLI 2.0](https://github.com/Azure/azure-cli) through the following command. Make sure you selected your subscription by `az account set --subscription <name or id>` and you have the privileges to create service principals.

```bash
az ad sp create-for-rbac --sdk-auth > my.azureauth
```

If you don't have Azure CLI installed, you can also do this in the [cloud shell](https://docs.microsoft.com/azure/cloud-shell/quickstart).
