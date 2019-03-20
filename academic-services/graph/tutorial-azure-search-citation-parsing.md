---
title: Create search webpage for Microsoft Academic Graph
description: Create search webpage using Microsoft Academic Graph and Azure Search
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 3/18/2019
---

# Create a search webpage using Microsoft Academic Graph and Azure Search

Step-by-step instructions for creating a webpage that allows users to search for publications in the Microsoft Academic Graph using an Azure Search service.

## Prerequisites

Complete these tasks before beginning this tutorial:

* [Set up provisioning of Microsoft Academic Graph to an Azure blob storage account](get-started-setup-provisioning.md)
* [Set up Azure Data Lake Analytics for Microsoft Academic Graph](get-started-setup-azure-data-lake-analytics.md).
* [Set up an Azure Search service of the Microsoft Academic Graph](tutorial-azure-search-setup.md)

## Gather the information that you need

   Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

   :heavy_check_mark:  The name of your Azure Data Lake Analytics (ADLA) service from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md).

   :heavy_check_mark:  The name of your Azure Data Lake Storage (ADLS) from [Set up Azure Data Lake Analytics](get-started-setup-azure-data-lake-analytics.md).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.