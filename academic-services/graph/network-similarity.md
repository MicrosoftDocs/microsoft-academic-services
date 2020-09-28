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

This package includes Python classes for Azure Databricks and U-SQL functions for Azure Data Lake Analytics. It also includes network embedding resources for sevaral academic entities similarity senses.

The functions/classes perform the following tasks.

1. Similarity comparison between 2 entities using pre-trained network embeddings on the MAG corpus, and
2. Compute top similar entities based on the pre-trained network embeddings.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Request Network Similarity Package when requesting MAG.

  > [!NOTE]
  > Network Similarity Package is not included in basic MAG distribution. Please ask for Network Similarity Package when requesting MAG. Otherwise it will not be included in your distribution.

## Available senses

The following senses are of entity embeddings that are currently available.
 
  |Entity Type|Sense|Description|
  |---|---|---|
  | affiliation | copaper | Two affiliations are similar if they are closed connected with each other in the weighted affiliation collaboration graph.|
  | affiliation | covenue | Two affiliations are similar if they publish in similar venues (journals and conferences).|
  | affiliation | metapath | Two affiliations are similar if they co-occur with common affiliations, venues, and fields of study.|
  | fos | copaper | Two fields of study are similar if they appear in the same paper.|
  | fos | covenue | Two fields of study are similar if they have papers from similar venues.|
  | fos | metapath | Two fields of study are similar if they co-occur with common affiliations, venues, and fields of study.|
  | venue | coauthor | Two venues are similar if they publish papers with common authors.|
  | venue | cofos | Two venues are similar if they publish papers with similar fields of study.|
  | venue | metapath | Two venues are similar if they co-occur with common affiliations, venues, and fields of study.|
  | author | copaper | Two authors are similar if they are closed connected with each other in the weighted author collaboration graph.|

## Sample

Follow these samples for detail usage information.

- [Network Similarity Sample (PySpark)](network-similarity-databricks.md)
- [Network Similarity Sample (U-SQL)](network-similarity-analytics.md)

## Reference

- PySpark version
  - [Constructor](network-similarity-databricks-constructor.md)
  - [getSimilarity](network-similarity-databricks-getsimilarity.md)
  - [getTopEntities](network-similarity-databricks-gettopentities.md)
- U-SQL version
  - [GetSimilarity](network-similarity-analytics-getsimilarity.md)
  - [GetTopEntities](network-similarity-analytics-gettopentities.md)

## Resource

* [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
