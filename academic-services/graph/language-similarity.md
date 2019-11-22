---
title: Language Similarity Package
description: Using Language Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# Using Language Similarity Package

Illustrates how to use Language Similarity Package to understand document semantics.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

> [!NOTE]
> Language Similarity Package is not included in basic MAG distribution. Please ask for Language Similarity Package when requesting MAG.

## Gather the information that you need

Before you begin, you should have these items of information:

   :heavy_check_mark:  The name of your Azure Storage (AS) account containing MAG dataset from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The access key of your Azure Storage (AS) account from [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md#note-azure-storage-account-name-and-primary-key).

   :heavy_check_mark:  The name of the container in your Azure Storage (AS) account containing MAG dataset.

   :heavy_check_mark:  The name of the output container in your Azure Storage (AS) account.

## Overloads

--- | ---
ComputeSimilarity(String, String) | Compute Similarity score between 2 strings
ComputeSimilarity(String, long) | Compute Similarity score between a string and a concept

## ComputeSimilarity(String, String)

Compute Similarity score between 2 strings.

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text1 | string | 
text2 | string | 

**Examples**

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```

## ComputeSimilarity(String, long)

Compute Similarity score between a string and a concept

   ```C#
   public static float ComputeSimilarity(string text, long fieldOfStudyId);
   ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text | string | 
fieldOfStudyId | long | 

**Examples**

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```

## GetTopFieldsOfStudy

Compute Similarity score between a string and a concept.

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text | string | 
maxCount | int | 
minScore | float | 


## Run scripts in the repository

1. Copy content in a script and paste into a new cell.

1. Press the **SHIFT + ENTER** keys to run the code in this cell. Please note that some scripts take more than 10 minutes to complete.

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/)
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html)
* [Import a Databrick notebook](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook)
* [Get started with Storage Explorer](https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer)
