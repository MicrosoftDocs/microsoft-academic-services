---
title: Network Similarity Package
description: Using Network Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/26/2019
---
# Network Similarity Package

The Microsoft Academic Network Similarity Package provides supplementary processing functionality for use with the Microsoft Academic Graph (MAG). This package includes network embedding resources for academic entities. It also includes U-SQL functions to be used in Azure Data Lake Analytics and Python classes for Azure Databricks.

The functions/classes perform the following tasks.

1. Similarity comparison between 2 entities using pre-trained network embeddings on the MAG corpus, and
2. Compute top similar entities based on the pre-trained network embeddings.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Request Network Similarity Package when requesting MAG.

  > [!NOTE]
  > Network Similarity Package is not included in basic MAG distribution. Please ask for Network Similarity Package when requesting MAG. Otherwise it will not be included in your distribution.

## Contents

The Network Similarity package is distributed in a separate folder (ns) in MAG. Files with usql extension are U-SQL scripts for Azure Data Lake Analytics. Files with py extension are Python script for Azure Databricks. Files with txt extension are network similarity resource files for different type of entities.

  ![Network Similarity folder](media/network-similarity/folder.png "Network Similarity folder")

## Examples

* [Network Similarity Example (Analytics)](network-similarity-analytics.md)
* [Network Similarity Example (Databricks)](network-similarity-databricks.md)

## Resource

* [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
