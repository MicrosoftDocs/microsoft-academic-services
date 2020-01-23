---
title: Get started with create MAKES API instances
description: Step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service(MAKES) APIs using MAKES management tool.
ms.topic: tutorial
ms.date: 01/03/2020
---

# Deploying a basic MAKES instance to Azure from your Subscription

 Step-by-step guide for deploying a basic MAKES instance from a Microsoft Academic Knowledge Exploration Service (MAKES) release. For more information on obtaining a MAKES release, visit [Get Microsoft Academic Knowledge Exploration Service on Azure storage](get-started-setup-provisioning.md)

## Prerequisites

- Microsoft Academic Knowledge Exploration Service (MAKES) subscription
- Azure subscription

## Verify the current release

When new versions of the MAKES are released, a new folder will be created on your Azure Storage Account.  In this folder will be all of the elements required to self-host an instance of MAKES.  To get started, let's verify that MAKES has been pushed to your subscription.

- Open the [Azure portal](https://portal.azure.com) and navigate to Storage Accounts.

- Find the Storage Account that you have set up for your MAKES subscription.

- Open the Storage Account in Storage Explorer.  This might require you to download the tool if you have not installed it already.

![Open in Explorer](media/get-started-open-storage-account.png)

- Once Storage Explorer has opened, verify that there is a blob container called "makes".

![Verify MAKES container](media/get-started-verify-makes-container.png)

- Open the "makes" blob container and verify there is at least one folder in that container.  This folder should be named by the date of the MAKES release.  Ex: 2020-01-10-prod

- Open the 'dated' folder, then verify there is a subfolder named 'tools'.

![Verify tools folder](media/get-started-tools-folder.png)

## Download the deployment script from your Azure Storage Account

Each MAKES deployment includes the scripts required to provision an instance of MAKES in Azure.  These tools are located in the 'tools' folder that you verified above.  To download the scripts, select the 'kesm.zip' file from Storage Explorer and click 'Download' from the top ribbon:

![Download kesm.zip](media/get-started-download-kesm.png)

Save this file to a local folder.

## Unzip the script package

Once the file has been downloaded you will need to extract the contents.  Right click on the kesm.zip file.  If you are using the Windows operating system select "Extract All" from the context menu.  If you are using linux, select "Extract Here" or "Unzip Here".  If you are using a Mac, double-click the zip file and it will decompress into the same folder.

If this has completed successfully you will have extracted a single file named kesm.exe.

## Run the script

At this point to are ready to deploy an instance of MAKES to your Azure account.  Open a command prompt (Windows) or terminal window (Mac) and navigate to the folder that you extracted the kesm.exe file to.

Execute the following command to deploy hosting resources

```cmd
kesm.exe DeployHost --HostName [whatever_name_you_would_like] --MakesPackage "https://[your_storage_account_name].blob.core.windows.net/makes/[release version]/"
```

- Replace "[whatever_name_you_would_like]" with the host name for your service.  The hostname will be the host name of the server where your MAKES deployment will be hosted.  Ex: If you used 'testmakes01102020', your MAKES API will be hosted at http://testmakes10012020.westus.cloudapp.azure.net

- Replace "[your_storage_account_name]" with the name of the storage account you downloaded the scripts from above.

At this point the tool will take care of creating all of the required resources and deploying your instance of MAKES.  This process can take a long time.  During the initial run it can take up to 3 hours to complete.  During the first run the script generates some resources that you only need to create once.  Subsequent deployments will not take as long if you specify existing resources.  See the [Command line Reference](reference-makes-command-line-tool.md) for more details.  

Depending on the region your storage account is in and the region you are deploying to, deployment may take longer as the default indexes are quite large and need to be copied.  By default, the tool deploys to the WestUS region of Azure.  You can change this by adding parameters to the script.  For a reference of all the available parameters type:

```cmd
kesm.exe help

// For command specific help; type the command, appending 'help'

kesm.exe DeployHost help
```

Or, you can visit the [kesm.exe Command Line Reference](reference-makes-command-line-tool.md).

## Next steps

Check out the sample projects that leverages MAKES API.