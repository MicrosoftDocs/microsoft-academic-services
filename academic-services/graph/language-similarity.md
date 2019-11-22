---
title: Language Similarity Package
description: Using Language Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# Language Similarity Package

Language Similarity Package is a package to understand document semantics. We put together  pre-trained models and concept-tagging algorithms as a software package that executes in the end user’s environment. Our customers can also tag, compare, and rebuild concept hierarchies based on any private corpus.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Request Language Similarity Package when requesting MAG.

> [!NOTE]
> Language Similarity Package is not included in basic MAG distribution. Please ask for Language Similarity Package when requesting MAG.

## Methods

* [ComputeSimilarity](language-similarity.md)
* [GetTopFieldsOfStudy](language-similarity.md)

## Run scripts in the repository

1. Copy content in a script and paste into a new cell.

1. Press the **SHIFT + ENTER** keys to run the code in this cell. Please note that some scripts take more than 10 minutes to complete.

## Resources

* [Create an Azure Databricks service](https://azure.microsoft.com/services/databricks/)
* [Create a cluster for the Azure Databricks service](https://docs.azuredatabricks.net/user-guide/clusters/create.html)
* [Import a Databrick notebook](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook)
* [Get started with Storage Explorer](https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer)
