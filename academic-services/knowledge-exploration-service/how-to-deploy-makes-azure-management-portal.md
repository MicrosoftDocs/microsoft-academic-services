---
title: Deploy API with Azure
description: Step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service APIs using the Azure Management Portal
ms.topic: tutorial
ms.date: 10/17/2018
---
# Deploy Microsoft Academic Knowledge Exploration Service API using Azure Management Portal

Details step-by-step guide for deploying Microsoft Academic Knowledge Exploration Service APIs using the Azure Management Portal.

## Configure API build

Before deploying a new MAKES API build it must first be configured to use the Azure storage account created to contain the builds.

### Load configuration file of MAKES API you want to deploy

1. Navigate to the Azure storage account

    ![Navigate to Azure storage account used for MAKES provisioning](media/configure-new-api-navigate-to-storage.png "Navigate to Azure storage account used for MAKES provisioning")

1. Navigate to the "makes" container in the "blobs" service tab

    ![Navigate to MAKES container that contains API builds](media/configure-new-api-navigate-to-container.png "Navigate to MAKES container that contains api builds")

1. Navigate to the MAKES API directory of the MAKES version you want to deploy and click the "configuration.cscfg" blob

    ![Navigate to the API directory and find API config](media/configure-new-api-navigate-to-config.png "Navigate to the API directory and find API config")

### Edit the "configuration.cscfg" blob

1. From the configuration.cscfg blob screen click the "edit blob" tab

    ![Click edit blob button to edit the configuration](media/configure-new-api-edit-blob.png "Click edit blob button to edit the configuration")

1. Change “_STORAGE_ACCOUNT_NAME_” to the Azure storage account name and “_STORAGE_ACCOUNT_ACCESS_KEY” to the Azure storage account primary key, then click “save”

    ![Change configuration details of API](media/configure-new-api-edit-details.png "Change configuration details of API")
    ![Click save after changes made to configuration](media/configure-new-api-edit-save.png "Click save after changes made to configuration")

    > [!IMPORTANT]
    > Make sure to do this for **each MAKES API you want to deploy**, i.e. if you want to deploy both the semantic-interpretation-engine and the entity-engine you will need to modify each APIs configuration file separately

    > [!IMPORTANT]
    > This only needs to be done **ONCE** for each new MAKES API build version

## Deploy MAKES API to new cloud service

1. Click the search box, type “cloud services” and click the “Cloud services (classic)” option

    ![Navigate to cloud services management section](media/deploy-new-go-to-cloud.png "Navigate to cloud services management section")

2. Add a new cloud service with a unique DNS name, using the same resource group that the Azure storage account is in, then click the “select a package” option

    ![Enter details for new cloud service](media/deploy-new-add-cloud-service.png "Enter details for new cloud service")

3. Enter a descriptive deployment label for the cloud service, check “deploy even if one or more roles contain a single instance”, and click “from blob” for package/configuration location

    ![Enter details for new deployment](media/deploy-new-configure-name.png "Enter details for new deployment")

4. Select MAKES API package

    Click "Package (.cspkg, .zip)"

    ![Click package tab to select new API package](media/deploy-new-select-package.png "Click package tab to select new API package")

    Enter the name of the Azure storage account you’re using for MAKES API builds, click the result and then click the “makes” container

    ![Find and select the storage account containing new API package](media/deploy-select-package-navigate.png "Find and select the storage account containing new API package")

    Navigate to the MAKES API build you want to deploy and click the package file (.cspkg) that corresponds to the type of cloud service type you want to host the API on, then click “select”

    ![Select the new MAKES API build package](media/deploy-select-package-pick-api.png "Select the new MAKES API build package")

    > [!IMPORTANT]
    > The name part after “package-“ corresponds to different types of pre-configured cloud service instances [detailed here](https://azure.microsoft.com/en-us/pricing/details/cloud-services/). **PLEASE NOTE THAT COSTS ASSOCIATED WITH DIFFERENT INSTANCE TYPES CAN VARY DRAMATICALLY.** See the “cloud service deployment options” section in the appendix for cost/benefit details of the different pre-configured cloud instance types.

5. Select the MAKES API configuration

    Click “Configuration (.cscfg)”

    ![Click configuration tab to select new API configuration](media/deploy-new-select-config.png "Click configuration tab to select new API configuration")

    Enter the name of the Azure storage account you’re using for MAKES API builds, click the result and then click the “makes” container

    ![Find and select the storage account containing new API config](media/deploy-select-config-navigate.png "Find and select the storage account containing new API config")

    Navigate to the MAKES API build you want to deploy, click the configuration file (.cscfg) and then click “select”

    ![Select the new MAKES API build config](media/deploy-select-config-pick-api.png "Select the new MAKES API build config")

6. Click "OK"

    ![Click ok button to upload new API package and configuration](media/deploy-new-select-ok.png "Click ok button to upload new API package and configuration")

7. Click "Create"

    ![Click create button to deploy new MAKES API](media/deploy-new-create-cloud-service.png "Click create button to deploy new MAKES API")

8. Wait for deployment to complete and MAKES API to fully come online

    Click the “go to resource” button once the cloud service deployment completes

    ![Go to cloud service resource once new deployment completes](media/deploy-new-go-to-cloud-service.png "Go to cloud service resource once new deployment completes")

    Verify that cloud service instance status is “starting”

    ![Verify new cloud service instance shows starting](media/deploy-new-cloud-service-starting.png "Verify new cloud service instance shows starting")

    Wait for cloud service instance status to show “running”

    ![Wait for new cloud service instance to show running](media/deploy-new-cloud-service-running.png "Wait for new cloud service instance to show running")

9. Verify that the new MAKES API instance is working

    To verify the entity API is working, navigate to https://your-entity-engine-cloud-service.cloudapp.net/evaluate?expr=And(Composite(AA.AuN=='darrin%20eide'),Ti=='an%20overview%20of%20microsoft%20academic%20service%20mas%20and%20applications')&attributes=Id,Ti&count=1 and verify “an overview of microsoft academic service mas and applications” is returned

    ![Verify new entity API is working by sending sample request](media/deploy-new-verify-entity.png "Verify new entity API is working by sending sample request")

    To verify the semantic interpretation API is working, navigate to https://your-semantic-interpretation-engine-cloud-service.cloudapp.net/interpret?query=darrin%20eide%20an%20overview%20of&complete=1&count=1 and verify that the top interpretation contains the expression “And(Composite(AA.AuN=='darrin eide'),Ti=='an overview of microsoft academic service mas and applications')”

    ![Verify new semantic interpretation API is working](media/deploy-new-verify-semantic.png "Verify new semantic interpretation API is working")

## Update existing MAKES API deployment with new build

1. Click the “update” button on the “overview” section of the cloud service to be updated

    ![Click update button in cloud service overview tab](media/deploy-update-click-button.png "Click update button in cloud service overview tab")

2. Enter a descriptive deployment label for the deployment, check “deploy even if one or more roles contain a single instance”, check “allow the update if role sizes change…” and click “from blob” for package/configuration location

    ![Enter configuration details for the deployment](media/deploy-update-configure.png "Enter configuration details for the deployment")

3. Select MAKES API package

    Click “Package (.cspkg, .zip)”

    ![Click package tab to select API package](media/deploy-update-select-package.png "Click package tab to select API package")

    Enter the name of the Azure storage account you’re using for MAKES API builds, click the result and then click the “makes” container

    ![Find and select the storage account containing API package](media/deploy-select-package-navigate.png "Find and select the storage account containing API package")

    Navigate to the MAKES API build you want to deploy and click the package file (.cspkg) that corresponds to the type of cloud service type you want to host the API on, then click “select”

    ![Select the MAKES API build package](media/deploy-select-package-pick-api.png "Select the MAKES API build package")

    > [!IMPORTANT]
    > The name part after “package-“ corresponds to different types of pre-configured cloud service instances [detailed here](https://azure.microsoft.com/en-us/pricing/details/cloud-services/). **PLEASE NOTE THAT COSTS ASSOCIATED WITH DIFFERENT INSTANCE TYPES CAN VARY DRAMATICALLY.** See the “cloud service deployment options” section in the appendix for cost/benefit details of the different pre-configured cloud instance types.

4. Select the MAKES API configuration

    Click “Configuration (.cscfg)”

    ![Click configure tab to select API configuration](media/deploy-update-select-config.png "Click configure tab to select API configuration")

    Enter the name of the Azure storage account you’re using for MAKES API builds, click the result and then click the “makes” container

    ![Find and select the storage account containing API config](media/deploy-select-config-navigate.png "Find and select the storage account containing API config")

    Navigate to the MAKES API build you want to deploy, click the configuration file (.cscfg) and then click “select”

    ![Select the MAKES API build config](media/deploy-select-config-pick-api.png "Select the MAKES API build config")

5. Click "OK"

    ![Click Ok button to upload API package and configuration](media/deploy-update-select-ok.png "Click Ok button to upload API package and configuration")

6. Click "Create"

    ![Click create button to deploy new API](media/deploy-new-create-cloud-service.png "Click create button to deploy new API")

7. Wait for deployment to complete and MAKES API to fully come online

    Click the “go to resource” button once the cloud service deployment completes

    ![Go to cloud service resource once complete](media/deploy-new-go-to-cloud-service.png "Go to cloud service resource once complete")

    Verify that cloud service instance status is “starting”

    ![Verify cloud service instance shows starting](media/deploy-new-cloud-service-starting.png "Verify cloud service instance shows starting")

    Wait for cloud service instance status to show “running”

    ![Wait for cloud service instance to show running](media/deploy-new-cloud-service-running.png "Wait for cloud service instance to show running")

8. Verify that the new MAKES API instance is working

    To verify the entity API is working, navigate to https://your-entity-engine-cloud-service.cloudapp.net/evaluate?expr=And(Composite(AA.AuN=='darrin%20eide'),Ti=='an%20overview%20of%20microsoft%20academic%20service%20mas%20and%20applications')&attributes=Id,Ti&count=1 and verify “an overview of microsoft academic service mas and applications” is returned

    ![Verify entity API is working by sending sample request](media/deploy-new-verify-entity.png "Verify entity API working is working by sending sample request")

    To verify the semantic interpretation API is working, navigate to https://your-semantic-interpretation-engine-cloud-service.cloudapp.net/interpret?query=darrin%20eide%20an%20overview%20of&complete=1&count=1 and verify that the top interpretation contains the expression “And(Composite(AA.AuN=='darrin eide'),Ti=='an overview of microsoft academic service mas and applications')”

    ![Verify semantic interpretation API is working](media/deploy-new-verify-semantic.png "Verify semantic interpretation API is working")