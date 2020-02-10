---
title: How to delete a MAKES API deployment
description: Step-by-step guide for deleting a Microsoft Academic Knowledge Exploration Service(MAKES) deployment using azure portal.
ms.topic: tutorial
ms.date: 02/06/2020
---

# How to delete a MAKES deployment

 Step-by-step guide for deleting a MAKES deployment created from MAKES command line tool. For more information on deploying a MAKES API instance, visit [Create an API Instance](get-started-create-api-instances.md)

## Prerequisites

- A MAKES API instance deployment

## Find the resource group associated with the MAKES API instance

There should be two resource groups associated with a MAKES API instance, a resource group containing the MAKES hosting image and a resource group containing the MAKES API instance. To find these resource groups:

1. Open the [Azure Management Portal](https://portal.azure.com) and navigate to resource groups.

1. Find the MAKES API instance resource groups by searching for the "HostName" parameter used for host deployment(DeployHost command).  

    You should the following MAKES API instance resources in your API instance resource group:
    ![makes deployment resources](media/makes-deployment-resources.png)

1. Find the hosting image resource group by searching for "HostResourceName" parameter used for hosting resource deployment(CreateHostResources command).  
    You should the MAKES hosting image resource in your hosting image resource group:
    ![makes hosting resources](media/makes-hosting-resources.png)

## Delete the resource group associated with the MAKES API instance

Delete both resources groups starting with the MAKES API instance resource group.

1. Click and open the resource group associated for the API instance.

1. Click "Delete resource group" and follow the prompt to delete the API instance resource group.

1. Once the API instance resource group is deleted, Click and the resource group associated with the hosting image.

1. Click "Delete resource group" and follow the prompt to delete the hosting image resource group.  
