---
title: Get started with create MAKES API instances
description: Step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service(MAKES) APIs using MAKES management tool.
ms.topic: tutorial
ms.date: 01/03/2020
---

# Deploying a basic MAKES instance to Azure from your Subscription

 Step-by-step guide for deploying a MAKES instance from a Microsoft Academic Knowledge Exploration Service (MAKES) release. For more information on obtaining a MAKES release, visit [Get Microsoft Academic Knowledge Exploration Service on Azure storage](get-started-setup-provisioning.md)

## Prerequisites

- Microsoft Academic Knowledge Exploration Service (MAKES) subscription
- Azure subscription

## 1. Verify the current release

When new versions of MAKES are released, a new folder will be created in the "makes" blob container of your Azure Storage Account.  In this folder will be all of the elements required to self-host an instance of MAKES.  To get started, let's verify that MAKES has been pushed to your subscription successfully.

- Open the [Azure portal](https://portal.azure.com) and navigate to Storage Accounts.

- Find the Storage Account that you have set up to receive your MAKES subscription.

- Open the Storage Account in *Storage Explorer*.  This might require you to download and install the tool if you have not installed it already.

![Open in Explorer](media/get-started-open-storage-account.png)

- Once Storage Explorer has opened, verify that there is a blob container called "makes".

![Verify MAKES container](media/get-started-verify-makes-container.png)

- Open the "makes" blob container and verify there is at least one folder in that container.  This folder should be named by the date of the MAKES release.  Ex: 2020-01-10-prod

- Open the 'dated' folder, then verify there is a sub folder named 'tools'.

![Verify tools folder](media/get-started-tools-folder.png)

## 2. Download the deployment script from your Azure Storage Account

Each MAKES deployment includes the scripts required to provision an instance of MAKES in Azure.  These tools are located in the 'tools' folder that you verified above.  To download the scripts, open the 'tools' folder, then open the 'kesm' folder.  Select the 'kesm.zip' file located in this folder from Storage Explorer and click 'Download' from the top ribbon:

![Download kesm.zip](media/get-started-download-kesm.png)

Save this file to a local folder.

## 3. Unzip the script package

Once the file has been downloaded you will need to extract the contents.  Right click on the kesm.zip file.  If you are using the Windows operating system select "Extract All" from the context menu.  If you are using a Mac, double-click the zip file and it will decompress into the same folder.  When extracted, you will see two folders, one for each environment we support.  Select win-x86 if you are using a Windows machine or osx-x64 if you will be running the script on a Mac and open the folder.  In this folder are two files: kesm.exe and kesm.pdb.  The kesm.exe file is script that we will be running to deploy MAKES.

## 4. Run the script

At this point to are ready to deploy an instance of MAKES to your Azure account.  Open a command prompt (Windows) or terminal window (Mac) and navigate to the folder that you extracted the kesm.exe file to.

Execute the following command to deploy hosting resources

```cmd
kesm.exe DeployHost --HostName [makes_instance_host_name] --MakesPackage "https://[makes_storage_account_name].blob.core.windows.net/makes/[makes_release_version]/"
```

- Replace "[makes_instance_host_name]" with the host name for your service.  The hostname will be the host name of the server where your MAKES deployment will be hosted.  Ex: If you used 'testmakes01102020', your MAKES API will be hosted at http://testmakes10012020.westus.cloudapp.azure.net

- Replace "[makes_storage_account_name]" with the name of the storage account you downloaded the scripts from above.

- Replace "[makes_release_version"] with the MAKES release you would like to deploy.

```cmd
kesm.exe DeployHost --HostName testmakes01102020 --MakesPackage "https://fooaccount.blob.core.windows.net/makes/2020-01-10-prod/"
```

At this point the tool will take care of creating all of the required resources and deploying MAKES.  During the initial run it can take up to 3 hours to complete this task.  On first run the script generates resources that you only need to create once.  Subsequent deployments to the same host will not take as long and should be much quicker, approximately 30 minutes->1 hour.  See the [Command line Reference](reference-makes-command-line-tool.md) for more details.  

> [!NOTE]
> To achieve the fastest instance start times, ensure that all resources (storage account, virtual machine scale set, etc.) are located in the same region. The "--Region" parameter controls which region new resources are created in. Visit the [Command line Reference](reference-makes-command-line-tool.md) section for full details on this and other parameters.

Depending on the region your storage account is in and the region you are deploying to, deployment may take longer as the default indexes are quite large and need to be copied.  By default, the tool deploys to the WestUS region of Azure.  For a reference of all the available parameters type:

```cmd
kesm.exe --help

// For command specific help; type the command, appending '--help'

kesm.exe DeployHost --help
```

Or, you can visit the [kesm.exe Command Line Reference](reference-makes-command-line-tool.md).

## Next steps

Check out the sample projects that leverages MAKES API.
