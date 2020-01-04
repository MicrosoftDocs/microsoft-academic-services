# MAKES command line tool

Makes command line tool is designed to help users create and host MAKES indexes.

## CreateHostResource Command

Creates the MAKES index hosting resources. E.g. MAKES web host image

## HostIndex Command

Hosts the specified indexes to power an instance of MAKES API.

## CreateBuildResources Command

Creates the MAKES index building resources. E.g. MAKES index build batch account, storage account.

## BuildIndex Command

Builds MAKES index(es) from json entities.

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
