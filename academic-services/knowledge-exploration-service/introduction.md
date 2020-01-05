---
title: About Microsoft Academic Knowledge Exploration Service
description: Microsoft Academic Knowledge Exploration Service enables self-hosted interactive search of entities in the Microsoft Academic Graph
ms.topic: overview
ms.date: 03/18/2018
---
# About Microsoft Academic Knowledge Exploration Service

Microsoft Academic Knowledge Exploration Service (MAKES) enables users to build interactive semantic search applications. Out of the box, users can host private instances of an interactive academic search API, powered by [Knowledge Exploration Service (KES) APIs](/azure/cognitive-services/KES/gettingstarted). The index powering the APIs are generated from  the [Microsoft Academic Graph](../graph/index.yml). These APIs are used to build [Microsoft Academic Website](https://academic.microsoft.com/)).

In addition to the academic index included with each release, users can also add their own data to customize the search experience.

## About Knowledge Exploration Service

Knowledge Exploration Service (KES) offers a fast and effective way to add interactive search and refinement to applications. With KES, you can build a compressed index from structured data, author a grammar that interprets natural language queries, and provide interactive query formulation with auto-completion suggestions.

KES is available as a completely stand-alone project. For details and documentation please see [this website](https://docs.microsoft.com/azure/cognitive-services/KES/overview).

For the sake of this document it’s important to understand that when a KES “API” is referenced it refers to a combination of a [compressed binary index](https://docs.microsoft.com/azure/cognitive-services/KES/gettingstarted#build-a-compressed-binary-index) and a [compiled SRGS grammar](https://docs.microsoft.com/azure/cognitive-services/KES/gettingstarted#compile-the-grammar), which are required for KES to operate.

Each API's index conforms to a [specific schema](https://docs.microsoft.com/azure/cognitive-services/KES/schemaformat), which defines what attributes are available and the operations that can be used to query them.
