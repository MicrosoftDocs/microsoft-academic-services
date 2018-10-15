---
title: About Knowledge Exploration Service
description: Knowledge Exploration Service offers a fast and effective way to add interactive search and refinement to applications
ms.topic: overview
---
# About Knowledge Exploration Service

Knowledge Exploration Service (KES) offers a fast and effective way to add interactive search and refinement to applications. With KES, you can build a compressed index from structured data, author a grammar that interprets natural language queries, and provide interactive query formulation with auto-completion suggestions.

KES is available as a completely stand-alone project. For details and documentation please see [this website](https://docs.microsoft.com/en-us/azure/cognitive-services/KES/overview).

For the sake of this document it’s important to understand that when a KES “engine” is referenced it refers to a combination of a [compressed binary index](https://docs.microsoft.com/en-us/azure/cognitive-services/KES/gettingstarted#build-a-compressed-binary-index) and a [compiled SRGS grammar](https://docs.microsoft.com/en-us/azure/cognitive-services/KES/gettingstarted#compile-the-grammar), which are required for KES to operate. 

Each engine's index conforms to a [specific schema](https://docs.microsoft.com/en-us/azure/cognitive-services/KES/schemaformat), which defines what attributes are available and the operations that can be used to query them.