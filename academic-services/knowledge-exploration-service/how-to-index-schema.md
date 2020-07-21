---
title: Index schema
description: Defines the file format and structure for MAKES index schema
ms.topic: tutorial
ms.date: 7/1/2020
---

# Index schema files

Index schema files define the attribute structure of entities in an index, including their [name](#attribute-name), [data type](#attribute-types), [supported operations](#attribute-operations) and [synonyms](how-to-index-synonym.md).

They play a critical part in the design of a [MAKES API](reference-makes-api.md):

* They serve as the blueprint for defining entity structure in [entity data files](how-to-index-data.md) used to build an index
* Supported [attribute query expressions](concepts-query-expressions.md) are completely dependent on what [operations](#attribute-operations) are enabled for each attribute
* How [natural language queries](concepts-queries.md) are interpreted relies on the [type](#attribute-types) and [supported operations](#attribute-operations) of each attribute

## Components of an index schema

``` JSON
{
    "attributes": [
        {
            "name": "name_of_attribute",
            "description": "description of attribute",
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

## Attribute description

Attribute descriptions are optional and solely for documentation. They have no functional role in the index, though they are stored in the binary index once it is built and can be retrieved when requesting information about the index.

## Attribute types

Name | Description | Supported operations | Example
--- | --- | --- | ---
blob | Internally compressed non-indexed data, useful for storing large amounts of data | | "It was the best of times, it was the worst of times ... It is a far, far better thing that I do, than I have ever done; it is a far, far better rest that I go to than I have ever known."
composite | Composition of one or more non-composite attributes | | See [composite attribute](#composite-attributes) section
date | Date value in YYYY-MM-DD format with supported range of 1400-01-01 to 9999-12-31 | equals, is_between | "2015-05-18"
double | Double-precision floating-point value | equals, starts_with, is_between | 2.71828182846
guid | Globally unique identifier value in XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX format | equals | "3d119f86-dcf0-4e35-9c01-b84832d851e9"
int32 | Signed 32-bit integer | equals, starts_with, is_between | -1, 0, 2015
int64 | Signed 64-bit integer | equals, starts_with, is_between | -1, 0, 8589934592
string | String of up to 1024 characters | equals, starts_with | "an overview of microsoft academic service mas and applications"

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

## Example

### Academic paper entity schema

The following schema definition is for an index that supports academic paper entities, and is part of the larger [MAKES customization tutorial](tutorial.md). It is meant to be a subset of the full [MAKES academic entity schema](reference-makes-api-entity-schema.md).

``` JSON
{
  "attributes": [
    {
      "name": "AA",
      "description": "Author-affiliation composite type",
      "type": "Composite*"
    },
    {
      "name": "AA.AfId",
      "description": "Affiliation ID",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AA.AfN",
      "description": "Normalized affiliation name",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "AffiliationSynonyms.txt"
    },
    {
      "name": "AA.AuId",
      "description": "Author ID",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AA.AuN",
      "description": "Normalized author name",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "AuthorSynonyms.txt"
    },
    {
      "name": "AA.DAfN",
      "description": "Original affiliation name",
      "type": "blob?"
    },
    {
      "name": "AA.DAuN",
      "description": "Original author name",
      "type": "blob?"
    },
    {
      "name": "AA.S",
      "description": "Numeric position in author list",
      "type": "int32?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AW",
      "description": "Unique, normalized words in abstract, excluding stop words",
      "type": "string*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "C",
      "description": "Conference series composite type",
      "type": "Composite?"
    },
    {
      "name": "C.CId",
      "description": "Conference series ID",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "C.CN",
      "description": "Normalized conference series name",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "ConferenceSynonyms.txt"
    },
    {
      "name": "CC",
      "description": "Citation count",
      "type": "int32?"
    },
    {
      "name": "CI",
      "description": "Conference instance composite type",
      "type": "Composite?"
    },
    {
      "name": "CI.CIId",
      "description": "Conference instance ID",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "CI.CIN",
      "description": "Normalized conference instance name",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "D",
      "description": "Publication date in YYYY-MM-DD format",
      "type": "date?",
      "operations": [
        "equals",
        "is_between"
      ]
    },
    {
      "name": "DN",
      "description": "Original paper title",
      "type": "blob?"
    },
    {
      "name": "DOI",
      "description": "Digital Object Identifier",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ]
    },
    {
      "name": "F",
      "description": "Field of study composite type",
      "type": "Composite*"
    },
    {
      "name": "F.DFN",
      "description": "Original field of study name",
      "type": "blob?"
    },
    {
      "name": "F.FId",
      "description": "Field of study ID",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "F.FN",
      "description": "Normalized field of study name",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "FieldOfStudySynonyms.txt"
    },
    {
      "name": "FP",
      "description": "First page of paper in publication",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "IA",
      "description": "Inverted abstract",
      "type": "blob?"
    },
    {
      "name": "Id",
      "description": "Entity ID",
      "type": "int64!",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "LP",
      "description": "Last page of paper in publication",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "RId",
      "description": "List of referenced paper IDs",
      "type": "int64*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "S",
      "description": "List of source URLs of the paper, sorted by relevance",
      "type": "blob?"
    },
    {
      "name": "Ti",
      "description": "Normalized paper title",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "W",
      "description": "Unique, normalized words in title, excluding stop words",
      "type": "string*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "Y",
      "description": "Publication year",
      "type": "int32?",
      "operations": [
        "equals",
        "is_between"
      ]
    }
  ]
}
```
