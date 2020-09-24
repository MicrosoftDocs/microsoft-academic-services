---
title: Network Similarity Package
description: Using Network Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# Network Similarity Package

The Microsoft Academic Network Similarity Package provides supplementary processing functionality for use with the Microsoft Academic Graph (MAG). For a detail description of the technology, please see [Multi-Sense Network Representation Learning in Microsoft Academic Graph](https://www.microsoft.com/research/project/academic/articles/multi-sense-network-representation-learning-in-microsoft-academic-graph/).

This package includes network embedding resources for academic entities. It also includes Python classes for use in Azure Databricks and U-SQL functions for Azure Data Lake Analytics.

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

The Network Similarity package is distributed in a separate folder (ns) in MAG.

* Files with .py extension are Python scripts for Azure Databricks.

  |File Name|Description|
  |---------|---------|
  |ns/PySparkNetworkSimilarityClass.py|PySpark utility functions for computing network similarity.|
  |ns/NetworkSimilaritySample.py|PySpark sample script for computing network similarity.|
  
* Files with .usql extension are U-SQL scripts for Azure Data Lake Analytics.

  |File Name|Description|
  |---------|---------|
  |ns/NetworkSimilarityFunction.usql|U-SQL utility functions for computing network similarity.|
  |ns/NetworkSimilaritySample.usql|U-SQL sample script for computing network similarity.|

* Files with .txt extension are network similarity resource files for different type of entities. Here are the description of the resource files.
 
  |File Name|Entity Type|Description|
  |---|---|---|
  |ns/AffiliationCopaper.txt|Affiliation|Two affiliations are similar if they are closed connected with each other in the weighted affiliation collaboration graph.|
  |ns/AffiliationCovenue.txt|Affiliation|Two affiliations are similar if they publish in similar venues (journals and conferences).|
  |ns/AffiliationMetapath.txt|Affiliation|Two affiliations are similar if they co-occur with common affiliations, venues, and fields of study.|
  |ns/FosCopaper.txt|Field of study|Two fields of study are similar if they appear in the same paper.|
  |ns/FosCovenue.txt|Field of study|Two fields of study are similar if they have papers from similar venues.|
  |ns/FosMetapath.txt|Field of study|Two fields of study are similar if they co-occur with common affiliations, venues, and fields of study.|
  |ns/VenueCoauthor.txt|Venue|Two venues are similar if they publish papers with common authors.|
  |ns/VenueCofos.txt|Venue|Two venues are similar if they publish papers with similar fields of study.|
  |ns/VenueMetapath.txt|Venue|Two venues are similar if they co-occur with common affiliations, venues, and fields of study.|
  |ns/AuthorCopaper.txt|Author|Two authors are similar if they are closed connected with each other in the weighted author collaboration graph.|

## Samples

* [Network Similarity Sample (U-SQL)](network-similarity-analytics.md)
* [Network Similarity Sample (PySpark)](network-similarity-databricks.md)

## Resource

* [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
