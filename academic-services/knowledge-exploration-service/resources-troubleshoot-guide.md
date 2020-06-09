---
title: MAKES troubleshooting guide
description: Addresses common problems found with MAKES
ms.topic: reference
ms.date: 2020-04-15
---

# Troubleshoot Common MAKES Command Line Tool Issues

## Azure login failure due to multiple subscriptions or multiple tenants being tied to a single Azure account

If you have multiple Azure tenants associated with a single Azure account, you'll need to specify the Azure Active Directory directory domain name associated with the Azure Subscription that you would like to use to execute the command. (e.g. "--AzureActiveDirectoryDomainName constco.onmicrosoft.com").  

You can find this information by logging into the Azure Management Portal, searching for "Azure Active Directory" and viewing the resource detail page. The domain name to use will be in the "Overview" section at the top left.

If you have multiple subscriptions associated with the same Azure Active Directory doamin and want to use the non-default subscription, you'll need to specify the subscription Id associated with the subscription to execute the command. (e.g. "--AzureSubscriptionId XXXXXXX-XXXX-XXX-XXXX-XXXXXXX")

You can find this information by logging into the Azure Management Portal, searching for **Subscriptions** and viewing the resource detail page. The subscription Id will be listed in the table.

## Azure Subscription quota limit reached

If you encounter errors such as "operation could not be completed as it results in exceeding approved XXXXXX quota", you can to contact Azure support to increase your account quota, try a different region where you have more Azure quota, or change the MAKES host machine SKU/worker machine SKU parameter. 

When running **CreateHostResources** command:

    Requires at least your subscription to have at least 4 avaliable vCPU cores and ability to create **Standard_DS4_v2** Virtual Machines. 

When running **DeployHost** command:

    By default, uses Virtual Machine SKU **Standard_D14_v2**. (Running the command by default requires your subscription to have access to at least 16 vCPU and ability to Virtual Machine with **Standard_D14_v2** SKU in west us region.) For most Microsoft Academic sub-graph index, you can scale down to **Standard_D8_v3** sku to host the indexes. 

When running **BuildIndex** command:

    You can use the default Virtual Machine SKU **Standard_D8_v3** for most Microsoft Academic sub-graph index builds. You can change the configuration to **Standard_D14_v2** or larger machines for faster builds, if you already have access to the number of vCPU and Virtual Machine SKU. 

You can contact Azure support to increase Subscription limits by submitting a request on Azure Management Portal. For more information, see [How to Create Azure Support Request](https://docs.microsoft.com/azure/azure-portal/supportability/how-to-create-azure-support-request)

## Azure Batch service not registered

When running **CreateIndexResources** command, if you encounter an error message containg "The subscription registration is in 'Unregistered' state. The subscription must be registered to use namespace 'Microsoft.Batch'....", you'll need to register your subscription to use Azure Batch service.

You can use the Azure Management Portal to register Azure Batch service for your subscription. To do this, log into the [Azure Management Portal](https://portal.azure.com)), search for **Subscriptions** and select the subscription you want to register Azure Batch service under. Then, select **Resource providers** and search for **Microsoft.Batch**. Finally, select **Microsoft.Batch** from the provider list and select **register**. This should only take a few minutes.

## Incomplete MAKES release transfer

A release may not be completed when you see a new folder in your storage account. Please allow 1 day after new release folder creation for all the necessary files to be transferred.

## MAKES hosting resource/deployment region mismatch

When running **DeployHost** command, If you encounter an error messages containing "...The Image '/subscriptions/XXXXXXX-XXXX-XXX-XXXX-XXXXXXX/resourceGroups/xxxxmakeshostres/providers/Microsoft.Compute/images/xxxxmakeshostres' cannot be found in 'xxxx' region...", make sure to create MAKES deployments and hosting images in the same region.

MAKES host can only be deployed the same region as the MAKES hosting image. Use the same --Region parameter as you did when running **CreateHostResources** command.

## Melformed path parameters

Special characters in parameters need to be escaped when using the Command Line Tool (kesm.exe). You can escape the whole parameter string by using quotes. E.g. --MakesPackage "https://consto.blob.core.windows.net/makes/2020-01-23/"

*Quotation charactors need to be straight. Ex: "ParamValue". Using any other qutotation charactor is will result in an error.  Ex: “ParamValue”

## Command Line Tool (kesm.exe) version mismatch

Use the command line tool that is contained in each release to customize and deploy MAKES. Previous versions of the kesm.exe tool are unsupported for new releases.  

## MAKES deployment failure due to bad MAKES hosting image  

MAKES hosting image creation may fail due to Azure outages or failures. If you cannot reach your MAKES status endpoint (http://<deploymentName>.<deploymentRegion>.cloudapp.azure.net/status), please try creating the MAKES hosting image again using the command line tool(kesm.exe).

## MAKES BuildIndex job hangs with no task failures

The underlying worker node for a BuildIndex job may have gone into an error state. Check the node status using the following steps:  

1. Find the batch resource associated with the BuildIndex job
    1. Open [Azure Management Portal](https://portal.azure.com)
    1. Search for the batch resource associated with the BuildIndex job by typing in the **IndexResourceName** used for the CreateIndexResources command
    1. Open the batch account resource that matches the **IndexResourceName**.
        ![batch-account-detail-page](media/batch-account-detail-page.png)
1. Open up BuildIndex job's pool detail
    1. Select **Jobs**
    1. Find the BuildIndex job by the job ID
    1. Select the job pool
        ![select-job-pool-from-jobs-page](media/select-job-pool-from-jobs-page.png)
1. Open error nodes detail page to inspect the  failure
    1. Select **Nodes**
    1. Select the node that's in an unhealthy state to view the error
        ![node-error-detail-page](media/node-error-detail-page.png)

If the error shows "There is not enough disk space on the node..." re-submit the job with a higher worker count and partition count by using the --WorkerCount and --IndexPartitionCount command. Otherwise, select **reboot** to restart the failed node.  

## MAKES BuildIndex job hangs with task failures due to data transfer

If your have large input entities data, BuildIndex job may encounter data transfer failure due to latency or throttling by Azure. To prevent failures due to data transfer, co-locate the input/output data storage account in the same region as the index build resources.
