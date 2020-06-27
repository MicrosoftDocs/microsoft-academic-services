---
title: Index schema
description: Defines the 
ms.topic: reference
ms.date: 7/1/2020
---

# Index schema files

Index schema files define the attribute structure of entities in an index, including their [name](#attribute-name), [data type](#attribute-types), [supported operations](#attribute-operations) and [synonyms](#attribute-synonyms).

They are a critical part of the design of a [MAKES API](reference-makes-api.md):

* They serve as the blueprint for defining entity data in [data files](reference-index-data.md) used to build an index
* Supported [attribute query expressions](concepts-query-expressions.md) are completely dependent on what [operations](#attribute-operations) are enabled for each attribute
* How [natural language queries](concepts-queries.md) are interpreted relies on the [type](#attribute-types) and [supported operations](#attribute-operations) of each attribute

## Components of an index schema

``` JSON
{
    "attributes": [
        {
            "name": "name_of_attribute",
            "type": "string | int32 | int64 | double | date | guid | blob | composite",
            "operations": ["operation1", "operation2", ... ],
            "synonyms": "synonym_file"
        },
        ...
    ]
}
```

## Attribute name

Attribute names must be composed of alphanumeric characters (a-z, A-Z,  0-9) or underscores, with the first character required to be an alpha character or underscore.

Examples of valid names:

* attributeName
* attribute_name
* _attr
* _012

Examples of invalid names:

* 0attr
* $attributeName
* attribute-name

In addition names can also contain a [composite group](#composite-attributes) name scoping prefix in the form of "composite_group_name.", which indicates the attribute is a sub-attribute of the composite group. Both the composite group name and the sub-attribute name must follow the same naming rules defined above, i.e.:

* Valid: composite_group_name.subAttributeName
* Invalid: composite-group-name.5thAttribute

## Attribute types

Name | Description | Supported operations | Example
--- | --- | --- | ---
string | String of up to 1024 characters | equals, starts_with | "an overview of microsoft academic service mas and applications"
int32 | Signed 32-bit integer | equals, starts_with, is_between | -1, 0, 2015
int64 | Signed 64-bit integer | equals, starts_with, is_between | -1, 0, 8589934592
double | Double-precision floating-point value | equals, starts_with, is_between | 2.71828182846
date | Date value in YYYY-MM-DD format with supported range of 1400-01-01 to 9999-12-31 | equals, is_between | "2015-05-18"
guid | Globally unique identifier value in XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX format | equals | "3d119f86-dcf0-4e35-9c01-b84832d851e9"
blob | Internally compressed non-indexed data, useful for storing large amounts of data | | "It was the best of times, it was the worst of times ... It is a far, far better thing that I do, than I have ever done; it is a far, far better rest that I go to than I have ever known."
composite | Composition of one or more non-composite attributes | | See [composite attribute](#composite-attributes) section

## Composite attributes

Composite attributes are used to represent a grouping of attributes and their corresponding values. The composite group is defined separately from its sub-attributes, with the sub-attributes prefixed by the composite group name and a period ("."):

``` JSON
"attributes": [
    {
        "name": "name_of_composite_attribute",
        "type": "composite"
    },
    {
        "name": "name_of_composite_attribute.name_of_composite_sub_attribute1",
        "type": "string | int32 | int64 | double | date | guid | blob",
        "operations": ["operation1", "operation2", ... ],
        "synonyms": "synonym_file"
    },
    {
        "name": "name_of_composite_attribute.name_of_composite_sub_attribute2",
        "type": "string | int32 | int64 | double | date | guid | blob",
        "operations": ["operation1", "operation2", ... ],
        "synonyms": "synonym_file"
    },
    ...
]
```

> [!IMPORTANT]
> Composite values **can not** be nested, hence sub-attributes can not have the type "composite"

## Attribute operations

Operations define the different ways that an attribute can be queried  using [structured query expressions](concepts-query-expressions.md).

Name | Description | Supported types | Example
--- | --- | --- | ---
equals | Enables exact matching of attribute values (including synonyms if defined) | string, int32, int64, double, date, guid | string_attribute == "canonical value", string_attribute = "canonical or synonym value", numeric_attribute == 10
starts_with | Enables prefix matching of attribute values (including synonyms if defined) | string, int32, int64, double | string_attribute == "beginning of value"...
is_between | Enables inequality matching (<, <=, >=, >) of attribute values | int32, int64, double, date | numeric_attribute >= 10, date_attribute > "2020-01-01"

## Attribute synonyms

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
> Synonym maps can be used for multiple different attributes. A common use case for this is generating word stems as canonical values and providing the [lemmatized forms](https://en.wikipedia.org/wiki/Lemmatisation) in a synonym map.

## Example

