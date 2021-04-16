---
title: Network Similarity Package
description: Using Network Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 4/16/2021
---

# Network Similarity Package

The Microsoft Academic Network Similarity Package provides supplementary processing functionality for use with the Microsoft Academic Graph (MAG). For a detail description of the technology, please see [Multi-Sense Network Representation Learning in Microsoft Academic Graph](https://www.microsoft.com/research/project/academic/articles/multi-sense-network-representation-learning-in-microsoft-academic-graph/).

This package includes Python classes for Azure Databricks and U-SQL functions for Azure Data Lake Analytics. It also includes network embedding resources for sevaral academic entities similarity senses.

The functions/classes perform the following tasks.

1. Similarity comparison between 2 entities using pre-trained network embeddings on the MAG corpus, and
1. Compute top similar entities based on the pre-trained network embeddings.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Set up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

## Available senses

The following senses are of entity embeddings that are currently available.

  | Entity Type | Sense | Description |
  | --- | --- | --- |
  | affiliation | cofos | Two affiliations are similar if they publish papers with similar fields of study. |
  | affiliation | copaper | Two affiliations are similar if they are closed connected with each other in the weighted affiliation collaboration graph. |
  | affiliation | covenue | Two affiliations are similar if they publish in similar venues (journals and conferences). |
  | affiliation | metapath | Two affiliations are similar if they co-occur with common affiliations, venues, and fields of study. |
  | author | copaper | Two authors are similar if they are closed connected with each other in the weighted author collaboration graph. |
  | conference | coauthor | Two conferences are similar if they publish papers with common authors. |
  | conference | cofos | Two conferences are similar if they publish papers with similar fields of study. |
  | conference | metapath | Two conferences are similar if they co-occur with common affiliations, venues, and fields of study. |
  | fos | coauthor | Two fields of study are similar if they have papers with common authors. |
  | fos | copaper | Two fields of study are similar if they appear in the same paper. |
  | fos | covenue | Two fields of study are similar if they have papers from similar venues. |
  | fos | metapath | Two fields of study are similar if they co-occur with common affiliations, venues, and fields of study. |
  | journal | coauthor | Two journals are similar if they publish papers with common authors. |
  | journal | cofos | Two journals are similar if they publish papers with similar fields of study. |
  | journal | metapath | Two journals are similar if they co-occur with common affiliations, venues, and fields of study. |

## Sample

Follow these samples for detailed usage information.

* [Network Similarity Sample (PySpark)](samples-databricks-network-similarity.md)

* [Network Similarity Sample (U-SQL)](samples-usql-network-similarity.md)

## Reference

* PySpark version
  * [Constructor](network-similarity-databricks-constructor.md)
  * [getSimilarity](network-similarity-databricks-getsimilarity.md)
  * [getTopEntities](network-similarity-databricks-gettopentities.md)

* U-SQL version
  * [GetSimilarity](network-similarity-usql-getsimilarity.md)
  * [GetTopEntities](network-similarity-usql-gettopentities.md)

## Resource

* [Multi-Sense Network Representation Learning in Microsoft Academic Graph](https://www.microsoft.com/research/project/academic/articles/multi-sense-network-representation-learning-in-microsoft-academic-graph/)

* [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
