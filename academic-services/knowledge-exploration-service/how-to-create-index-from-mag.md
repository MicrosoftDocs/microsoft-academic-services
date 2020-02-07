---
title: Create index from Microsoft Academic Graph(MAG)
description: Step-by-step guide for generating MAKES indexes from a MAG release.
ms.topic: tutorial
ms.date: 0
---

# Generating MAKES indexes from a MAG release

 Step-by-step guide for generating MAKES indexes from a Microsoft Academic Graph(MAG) release. For more information on obtaining a MAG release, visit [Get Microsoft Academic Graph on Azure storage](../graph/get-started-setup-provisioning.md)

## Prerequisites

- Microsoft Academic Graph(MAG) release
- Microsoft Academic Knowledge Exploration Service(MAKES) release
- Azure subscription

## Generating MAKES entities using USQL

## Build index using MAKES command line tool

### Create indexing resources

```CMD

kesm.exe CreateIndexResources --IndexResourceName "alchmakesindexres" --MakesPackage "https://alchmakesstore.blob.core.windows.net/makes/2020-01-30/" --MakesIndexResourceConfigFilePath "makesIndexResConfig" --Region westus2 --AzureCredentialsFilePath "my.azureauth"

``
### Submit index build job

## Next steps

    - [Create MAKES API instances](get-started-create-api-instances.md)
