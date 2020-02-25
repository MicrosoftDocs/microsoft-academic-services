---
title: Common entity attributes
description: Learn the common attributes you can use with all entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 2020-02-24
---

# Entity Attributes

The academic graph is composed of 7 types of entity. All entities will have an Entity ID and an Entity type.

## Common Entity Attributes

Name | Description | Type | Operations
--- | --- | --- | ---
Id | Entity ID | Int64 | Equals
Ty | Entity type | enum | Equals

## Entity type enum

Name | Value
--- | ---
[Paper](reference-paper-entity-attributes.md) | 0
[Author](reference-author-entity-attributes.md) | 1
[Journal](reference-journal-entity-attributes.md) | 2
[Conference Series](reference-conference-series-entity-attributes.md) | 3
[Conference Instance](reference-conference-instance-entity-attributes.md) | 4
[Affiliation](reference-affiliation-entity-attributes.md) | 5
[Field Of Study](reference-field-of-study-entity-attributes.md) | 6