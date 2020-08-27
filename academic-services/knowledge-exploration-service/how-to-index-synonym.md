---
title: Synonyms
description: Defines the file format and structure for synonym data in MAKES
ms.topic: how-to
ms.date: 9/1/2020
---

# Synonym files

Synonyms map equivalent terms that implicitly expand the scope of a query, without users having to know canonical terms. For example, given an entity with a string attribute "pet_type" having the canonical value of "canine" we could define the synonyms "dog" and "puppy" which would allow queries containing any of the terms "canine", "dog" or "puppy" to match the entity.

## Synonym data file format

Synonyms are defined on a per-entity attribute basis, with the schema attribute "synonyms" value representing the name of the synonym data file. The data file is simply a list of string tuples, with the first item representing a canonical value the second item a synonymous value:

``` JSON
["canonical_value1", "synonymous_value1"]
["canonical_value2", "synonymous_value1"]
["canonical_value2", "synonymous_value2"]
["canonical_value3", "synonymous_value3"]
```

> [!NOTE]
> Synonym mappings are many-to-many, meaning a single canonical value can have multiple synonymous values and conversely a single synonymous value can have multiple canonical values.

> [!NOTE]
> A single synonym data file can be used for multiple *different* entity attributes. A common use case for this are full-text attributes, where word stems are used as canonical values and [lemmatized forms](https://en.wikipedia.org/wiki/Lemmatisation) of the stem are used as synonyms.

## Example

### Academic conference synonyms

Academic conference names are a great use case for synonyms, as they can have a variety of transformations (i.e. abbreviation, truncation, etc.) applied to them.

For this example we generate synonyms for the ["Knowledge Discovery and Data Mining" conference](https://academic.microsoft.com/conference/1130985203).

Conference series synonyms:

``` JSON
["kdd", "knowledge discovery and data mining"]
["kdd", "kdd knowledge discovery and data mining"]
["kdd", "acm sigkdd"]
["kdd", "sigkdd"]
```

Conference instance synonyms:

``` JSON
["kdd 2019", "25th sigkdd conference on knowledge discovery and data mining"]
["kdd 2019", "knowledge discovery and data mining 2019"]
["kdd 2019", "kdd knowledge discovery and data mining 2019"]
["kdd 2019", "acm sigkdd 2019"]
["kdd 2019", "sigkdd 2019"]
```

## Next steps

Advance to the next sections to learn about defining index data.

> [!div class="nextstepaction"]
>[Define data](how-to-index-data.md)