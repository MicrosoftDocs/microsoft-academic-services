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

1. Open the [Azure portal](https://portal.azure.com) and navigate to resource groups.

2. Find the MAKES API instance resource groups by searching for the "HostName" parameter used for host deployment(DeployHost command).  

3. Find the hosting image resource group by searching for "HostResourceName" parameter used for hosting resource deployment(CreateHostResources command).  

## Delete the resource group associated with the MAKES API instance

Delete both resources groups.

1. Click and open the resource group associated for the API instance.

2. Click "Delete resource group" and follow the prompt to delete the API instance resource group.

3. Once the API instance resource group is deleted, Click and the resource group associated with the hosting image.

4. Click "Delete resource group" and follow the prompt to delete the hosting image resource group.  