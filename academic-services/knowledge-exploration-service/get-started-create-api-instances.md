---
title: Get started with create MAKES API instances
description: Step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service(MAKES) APIs using MAKES management tool.
ms.topic: tutorial
ms.date: 10/16/2020
---

# Deploying a basic MAKES instance to Azure from your Subscription

 Step-by-step guide for deploying a Microsoft Academic Knowledge Exploration Service (MAKES) instance from a MAKES release. For more information on obtaining a MAKES release, visit [Sign up for MAKES](get-started-setup-provisioning.md)

## Prerequisites

- Microsoft Academic Knowledge Exploration Service (MAKES) subscription. See [Get started with Microsoft Academic Knowledge Exploration Service](get-started-setup-provisioning.md) to obtain one.
- Azure Subscription. The Azure Subscription must be able to create virtual machine with "Standard_DS4_v2" SKU. See [Azure Subscription quota limit reached](resources-troubleshoot-guide.md#azure-subscription-quota-limit-reached) for more information.

## Verify the folders and content of the current release

When new versions of MAKES are released, a new folder will be created in the "makes" blob container of your Azure Storage Account.  This folder contains all the elements required to self-host an instance of MAKES.  To get started, let's verify that MAKES has been published to your subscription successfully.

1. Open the [Azure Management Portal](https://portal.azure.com) and navigate to **Storage Accounts**.

1. Find the Storage Account that you set up to receive your MAKES subscription.

1. Open the Storage Account in **Storage Explorer**.  This might require you to download and install the tool if you have not installed it already.

    ![Open in Explorer](media/get-started-open-storage-account.png)

    Once Storage Explorer has opened, verify that there is a blob container called **makes**.

    ![Verify MAKES container](media/get-started-verify-makes-container.png)

1. Open the **makes** blob container; verify there is at least one folder in that container.  This folder should be named by the date of the MAKES release.  Ex: 2020-01-30

1. Open the 'dated' folder.
    There should be four (4) folders and a licence:
    - **grammar** - This folder holds the grammar files.
    - **index** - This folder holds the index files.
    - **tools** - This folder holds the command line tool and worker packages required to customize MAKES and deploy MAKES to Azure.
    - **webhost** - This folder holds the files required to create the VM instance of MAKES.
    - **License.docx** - Microsoft Word file with the license to use this data and software.
    ![Verify tools folder](media/get-started-tools-folder.png)

## Download the command line tool (kesm.exe) from your Azure Storage Account

Each MAKES deployment includes a command line tool (kesm.exe) required to provision an instance of MAKES in Azure.  To download the command line tool, open the **tools** folder. Select the **kesm.zip** file. Then, select **Download** from the top ribbon:

![Download kesm.zip](media/get-started-download-kesm.png)

Save this file to a local folder.

## Unzip the kesm.zip package to access the command line tool (kesm.exe)

Once the file has been downloaded you will need to extract the contents.  Right click on the **kesm.zip** file.  If you are using the Windows operating system select **Extract All** from the context menu.  If you are using a Mac, double-click the zip file and it will decompress into the same folder. You will now see two folders, one for each environment we support.  Select **win-x86** if you are using a Windows machine or **osx-x64** if you will be running the command on a Mac and open the folder.  In this folder there is another folder, **Kesm**.  Open this folder. In this folder there are two files: **kesm.exe** and **kesm.pdb**.  The **kesm.exe** file is the executable that we will be running to deploy MAKES.

## Create MAKES hosting resources

> [!IMPORTANT]
> This command will run under your Azure credentials, have your Azure login credentials ready.
> The Azure Subscription used for the command must be able to create a virtual machine with "Standard_DS4_v2" SKU. See [Azure Subscription quota limit reached](resources-troubleshoot-guide.md#azure-subscription-quota-limit-reached) for more details.

At this point you are ready to deploy an instance of MAKES to your Azure account. We will start by creating an Azure VM Image that MAKES can use to deploy MAKES hosts. Kesm.exe will create the VM Image by spinning up a virtual machine with "Standard_DS4_v2" SKU. This image contains the necessary environment resources and configuration for MAKES to run inside Azure Machine Scale Sets and can be reused to generate more instances of MAKES.

1. Open a command prompt (Windows) or terminal window (Mac) and navigate to the folder that you extracted the **kesm.exe** file to.

1. Execute the following command to create your hosting resources:

    ```cmd
    kesm.exe CreateHostResources --HostResourceName <makes_host_resource_group_name> --MakesPackage "https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version>/"
    ```

    Example: **kesm.exe CreateHostResources --HostResourceName "contosorgmakesone" --MakesPackage "https://makesascontoso.blob.core.windows.net/makes/2020-01-30/"**

    Replace the following tokens in the command above with the appropriate value:

    | Token to relpace | Value |
    | --------| ----- |
    | <makes_host_resource_group_name> | The name of the Resource Group that will be created for this deployment. |
    | <makes_storage_account_name> | The name of the storage account you downloaded the scripts from above. |
    | <makes_release_version> | The MAKES release you would like to deploy. |

    The command will then prompt you to go to a secure website to authenticate.

> [!NOTE]
> If your account is connected to multiple Azure Directories or Azure Subscriptions, you'll also have to specify the **--AzureActiveDirectoryDomainName** and/or **--AzureSubscriptionId** parameters. See [Command Line Tool Reference](reference-makes-command-line-tool.md#common-azure-authentication-parameters) for more details.

1. Open a new browser window and copy the URL from the command.  Ex: **https://microsoft.com/devicelogin**

1. Enter the authentication code given to you from the command.

1. Use your id or email address to sign into your azure account.

    Once you have authenticated, you may close your browser window and the command will continue to run.  This command will take 20-30 mins to complete.

  >[!NOTE]
  >This command will take around 20-30 minutes to complete.  Once this command has been run, you can reuse the Host Image Id to deploy more instances of MAKES.

## Deploy a MAKES host instance to Azure

> [!IMPORTANT]
> This command will run under your Azure credentials, have your Azure login credentials ready.
> The Azure Subscription used for the command must be able to create a virtual machine with "Standard_D14_v2" SKU. See [Azure Subscription quota limit reached](resources-troubleshoot-guide.md#azure-subscription-quota-limit-reached) for more details.

Now that the MAKES hosting Virtual Machine Image is created, you are ready to use it to deploy MAKES hosts to a Virtual Machine Scale Set.

1. Copy the **Host Image Id** from the last line of output from the command, you will use it in the next command.  Ex:  **/subscriptions/<your_subscription_id>/resourceGroups/<makes_host_rource_group_name>/profiders/Microsoft.Compute/Images/<makes_host_rource_group_name>**

    ![Copy the Host Image Id](media/get-started-copy-makes-image-id.png)

1. Copy the following command to your command / terminal window to deploy your hosting resources:

    ```cmd
    kesm.exe DeployHost --HostName "<makes_instance_host_name>" --MakesPackage "https://<makes_storage_account_name>.blob.core.windows.net/makes/<makes_release_version>/"  --MakesHostImageId "<id_from_previous_command_output>"
    ```

    Replace the tokens in the command above with the appropriate value:

    | Token to relpace | Value |
    | --------| ----- |
    | <makes_instance_host_name> | The host name for your service. An Azure Resource Group, Virtual Machine Scale Set, and other related Azure resources will be created using the hostname. The hostname will also be the host name of the server where your MAKES deployment will be hosted.  Ex: If you used 'contosomakes', your MAKES API will be hosted at http://contosomakes.westus.cloudapp.azure.net. |
    | <makes_storage_account_name> | The name of the storage account you downloaded the scripts from above. |
    | <makes_release_version> | The MAKES release you would like to deploy. |
    | <id_from_previous_command_output> | The id you copied from the output of the previous command. |

    Example:

    ```cmd
    kesm.exe DeployHost --HostName contosomakes --MakesPackage "https://makesascontoso.blob.core.windows.net/makes/2020-01-30/" --MakesHostImageId "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/contosorgmakesone/profiders/Microsoft.Compute/Images/contosoImageName"
    ```

If necessary, authenticate the command in the same way as you did above for the first command.

>[!IMPORTANT]
>While this script is running, the admin name and password will be shown on the screen for the VM being created.  Make note of this for logging into the VM at a later time for any reason or if logging the output of this command, be sure to remove this information.

>[!NOTE]
>This command will take approximately 45 mins to complete if the VM image created by the first command is co-located (in the same Azure region) as your Azure storage account and you are using the standard ds14_v2 VM (this is the default).

At this point the tool will take care of creating all of the required resources and deploying MAKES.  As stated above, you can re-use the MAKES hosting image created from the CreateHostResources command for subsequent deployments to reduce the start-up time.  See the [Command line Reference](reference-makes-command-line-tool.md) for more details.  

> [!NOTE]
> To achieve the fastest instance start times, ensure that all resources (storage account, virtual machine scale set, etc.) are located in the same region. The "--Region" parameter controls which region new resources are created in. Visit the [Command line Reference](reference-makes-command-line-tool.md) section for full details on this and other parameters.

Depending on the region your storage account is in and the region you are deploying to, deployment may take longer as the default indexes are quite large and need to be copied.  By default, the tool deploys to the WestUS region of Azure.  For a reference of all the available commands type:

```cmd
kesm.exe --help
```

For command specific help. Type the command, appending '--help'

```cmd
kesm.exe DeployHost --help
```

Or, you can visit the [Command Line Tool(kesm.exe) Reference](reference-makes-command-line-tool.md).

## Verify your new instance of MAKES

1. Open a browser and go to the status URL for your new MAKES instance.  Ex: **http://<your_makes_public_IP_DNS>.<azure_region>.cloudapp.azure.com/status**. The "readyToServeRequest" property should be true.

1. Go to the details URL for your new MAKES instance and verify the version of the API. Ex: **http://<your_makes_public_IP_DNS>.<azure_region>.cloudapp.azure.com/details**.  In the description the created time should match the date of your release.

1. Go to the base URL for your new MAKES instance and verify the API's are working as expected.  Ex: **http://<your_makes_public_IP_DNS>.<azure_region>.cloudapp.azure.com**

## Next steps

Check out the sample projects that leverage the MAKES API.
