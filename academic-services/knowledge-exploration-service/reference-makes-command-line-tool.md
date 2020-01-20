# MAKES command line tool

Makes command line tool is designed to help users create and host MAKES indexes.

## CreateHostResources Command

Creates the MAKES index hosting resources. E.g. MAKES web host image

```cmd
kesm CreateHostResources --HostResourceName
            --MakesPackage
            --[Region]
            --[MakesWebHost]
```

### Required Parameters

`--HostResourceName`

The name of the host resource.  

`--MakesPackage`

The base URL to a MAKES release package.

### Optional Parameters

`--Region`

The region to deploy the host resources to. Defaults to WestUs

`--MakesWebHost`

The URL to MAKES web host zip file that will be used to create the MAKES virtual machine hosting image.

### Common Parameters

`--AzureActiveDirectoryDomainName`

The azure active directory domain name associated with the azure subscription that user would like to use to execute the command. This is not required if the user's azure account has only one azure subscription.

`--AzureCredentialsFilePath`

The path to the azure credential file to use for authentication.

## DeployHost Command

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

### Required Parameters

`--HostName`

The MAKES API host name. API name should be less than 64 characters with only numbers and lower case letters.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesHostImageId`

The MAKES host virtual machine image resource Id. Run CreateHostResource command to generate one.

### Optional Parameters

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

### Required Parameters

`--IndexResourceName`

The name for the indexing resources. Indexing resources name should be less than 64 characters with only numbers and lower case letters.

`--Region`

The region to create the indexing resources in.

`--MakesPackage`

The base URL to a MAKES release package.

`--MakesIndexResourceConfigFilePath`

Outputs the MAKES indexing resources config file for BuildIndex command. The command won't write a config file unless a path is provided.

### Optional Parameters

`--MakesPreprocessor`

The MAKES preprocessor zip url.

`--MakesIndexer`

The MAKES indexer zip url.

`--MakesJobManager`

The MAKES JobManager zip url.

## BuildIndex Command

Builds MAKES index(es) from json entities.

### Required Parameters

`--EntitiesUrlPrefix`

`--OutputUrlPrefix`

### Optional Parameters

`--IndexPartitionCount`

`--IntersectionMinCount`

`--MaxStringLength`

`--RemoveEmtpyValues`

## Common authentication parameters

MAKES command line tool leverages device login to access azure subscriptions by default. You can specify AzureActiveDirectoryDomainName and AzureCredentialsFilePath parameter to change the authentication behavior.

### AzureActiveDirectoryDomainName

If you have more than one azure subscription, you'll need to specify the Azure Active Directory domain name associated with the azure subscription you'd like to use. (e.g. "constco.onmicrosoft.com").

You can find this information by logging into azure portal and go to your Azure Active Directory resource detail page.

### AzureCredentialsFilePath

If you're using the command line tool often, you can generated an Azure credential file to avoid inputting your azure credentials each time you run an command.

You can generate this file using [Azure CLI 2.0](https://github.com/Azure/azure-cli) through the following command. Make sure you selected your subscription by `az account set --subscription <name or id>` and you have the privileges to create service principals.

```bash
az ad sp create-for-rbac --sdk-auth > my.azureauth
```

If you don't have Azure CLI installed, you can also do this in the [cloud shell](https://docs.microsoft.com/azure/cloud-shell/quickstart).
