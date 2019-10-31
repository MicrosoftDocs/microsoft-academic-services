---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Deploy Microsoft Academic Knowledge Exploration Service using KESM deployment tool

Details step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service using the KESM deployment tool that is distributed as part of the MAKES subscription.

## Prerequisites

1. Subscribe to [Microsoft Academic Knowledge Exploration Service](get-started-subscribe.md) releases
1. [Download and install Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)
1. Add your Azure subscription to Azure Storage Explorer

## Download the KESM tool

1. Navigate to the storage account where your MAKES subscription uploads new releases to.
1. Navigate to the most recent release of MAKES (makes/{mostRecentVersion}), making sure to note the mostRecentVersion name for later
1. Go to the tools folder and download kesm.zip
1. Navigate to kesm.zip in windows explorer and extract all files to your local disk (c:\kesm in this example)

## Find your Azure Active Directory domain name

1. In a browser window, navigate to <https://portal.azure.com>
1. Search for "aad" and open up "Azure Active Directory"
1. Note the "xxx.onmicrosoft.com" domain name shown above "Default Diretory"

## Deploy MAKES release using KESM tool

1. Open a new command window (windows key -> "cmd")
1. Navigate to the kesm directory
    1. Type "c:" and press enter
    1. Type  "cd kesm\win-x86\Kesm" and press enter
1. Enter the following command and press enter:
    ```
    Kesm.exe CreateHost
        --AzureActiveDirectoryDomainName {domainName}
        --MakesPackage https://{makesReleaseStorageAccount}.blob.core.windows.net/makes/{mostRecentVersion}/
        --HostName {serviceHostName}
        --Region {region}
        --Instances {instanceCount}
        --HostMachineSku {sku}
    ```
    - domainName is the Azure Active Directory domain name you found above
    - makesReleaseStorageAccount is the name of the storage account where your MAKES releases are stored
    - mostRecentVersion is the MAKES release version you want to deploy
    - serviceHostName is the name of the service to create, which will be used in the domain name that is created for the service deployment, i.e. <http://{serviceHostName}.{region}.cloudapp.azure.com>. Note that the name must me all lower-case letters/numbers with no punctuation
    - region is the Azure region to deploy the service in (e.g. westus, eastus, eastasia, etc.)
    - instanceCount is the number of service instances to create in the virtual machine scale set that is created
    - hostMachineSku is the virtual machine size to use for each VM instance created in the virtual machine scale set. See [Virtual Machine Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general) for a list of common skus

    Example:
    ```
    Kesm.exe CreateHost
        --AzureActiveDirectoryDomainName microsoft.onmicrosoft.com
        --MakesPackage https://makesstorage.blob.core.windows.net/makes/2019-10-25/
        --HostName makestest
        --Region westus
        --Instances 1
        --HostMachineSku Standard_DS4_v2
    ```
1. When prompted to sign in, follow the https://microsoft.com/devicelogin link and enter the provided code
1. Once signed in, the deployment will start and can take up to an hour or more depending on the size of the release. You will see a progress indicator while the release is being loaded on the service instances