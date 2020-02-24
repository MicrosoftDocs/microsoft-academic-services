---
title: Common entity attributes
description: Learn the common attributes you can use with all entities in the Project Academic Knowledge API.
ms.topic: reference
ms.date: 2020-02-24
---

# Entity Attributes

The academic graph is composed of 7 types of entity. All entities will have an Entity ID and an Entity type.

## Common Entity Attributes
Name	|Description	            |Type       | Operations
------- | ------------------------- | --------- | ----------------------------
Id		|Entity ID					|Int64		|Equals
Ty 		|Entity type 				|enum	|Equals

## Entity type enum
Name 															|value
----------------------------------------------------------------|-----
[Paper](PaperEntityAttributes.md)								|0
[Author](AuthorEntityAttributes.md)								|1
[Journal](JournalEntityAttributes.md)	 						|2
[Conference Series](JournalEntityAttributes.md)					|3
[Conference Instance](ConferenceInstanceEntityAttributes.md)	|4
[Affiliation](AffiliationEntityAttributes.md)					|5
[Field Of Study](FieldsOfStudyEntityAttributes.md)						|6

