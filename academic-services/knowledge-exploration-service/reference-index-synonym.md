---
title: Synonyms
description: Defines the file format and structure for synonym data in MAKES
ms.topic: reference
ms.date: 7/1/2020
---

# Synonym files

Synonyms map equivalent terms that implicitly expand the scope of a query, without users having to know canonical terms. For example, given an entity with a string attribute "pet_type" having the canonical value of "canine" we could define the synonyms "dog" and "puppy" which would allow queries containing any of the terms "canine", "dog" or "puppy" to match the entity.

Synonym maps are defined on a per-attribute basis, with the "synonyms" value representing a separate mapping file. The mapping file is simply a list of string tuples, with the first item representing a canonical value the second item a synonymous value:

``` JSON
["canonical_value1", "synonymous_value1"]
["canonical_value2", "synonymous_value1"]
["canonical_value2", "synonymous_value2"]
["canonical_value3", "synonymous_value3"]
```

> [!NOTE]
> Mappings are many-to-many, meaning a single canonical value can have multiple synonymous values and conversely a single synonymous value can have multiple canonical values.

> [!NOTE]
> A single synonym map can be used for multiple *different* attributes. A common use case for this are full-text attributes, where word stems are used as canonical values and [lemmatized forms](https://en.wikipedia.org/wiki/Lemmatisation) of the stem are used as synonyms.

## Example

