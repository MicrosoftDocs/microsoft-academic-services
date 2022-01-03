---
title: 'Define MAG functions'
description: Define functions to extract MAG data (U-SQL)
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 4/14/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Define MAG functions (U-SQL)

## Define functions to extract MAG data

In this section, you will submit an Azure Data Lake Analytics (ADLA) job to create functions extracting MAG data from Azure Storage (AS).

1. Download `samples/usql/CreateFunctions.usql` in MAG dataset to your local drive.<br>From [Azure portal](https://portal.azure.com), go to the Azure Storage account > **Containers > [MAG-Container] > mag > [yyyy-mm-dd] > samples > usql > CreateFunctions.usql > Download**.

   ![Download CreateFunctions.usql](media/samples-azure-data-lake-hindex/create-functions-download.png "Download CreateFunctions.usql")

1. Go to the Azure Data Lake Analytics (ADLA) service that you created, and select **Overview > New job > Open file**. Select `CreateFunctions.usql` in your local drive.

   ![New job - Open CreateFunctions.usql](media/samples-azure-data-lake-hindex/create-functions-open.png "New job - Open CreateFunctions.usql")

1. Select **Submit**.

   ![Submit CreateFunctions job](media/samples-azure-data-lake-hindex/create-functions-submit.png "Submit CreateFunctions job")

1. The job should finish successfully.

   ![CreateFunctions job status](media/samples-azure-data-lake-hindex/create-functions-status.png "CreateFunctions job status")
