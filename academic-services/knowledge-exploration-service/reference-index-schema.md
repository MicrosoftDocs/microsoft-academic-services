---
title: Index schema
description: Defines the 
ms.topic: reference
ms.date: 7/1/2020
---

# Index schema files

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
    ],
    "intersections-exclude": [ "attribute1", "attribute2", ... ]
}
```

## Attribute collection

The attributes collection ("attributes") is typically the largest (and most important) part of an index schema. It is where each attribute is named, typed, and has its indexing operations defined which determine how it is used.

## Attribute name

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
> Composite values cannot be nested, hence sub-attributes cannot have the type "composite"

## Indexing operations

Name | Description | Supported types | Example
--- | --- | --- | ---
equals | Enables exact matching of attribute values (including synonyms if defined) | string, int32, int64, double, date, guid | string_attribute == "canonical value", string_attribute = "synonym value", numeric_attribute == 10
starts_with | Enables prefix matching of attribute values (including synonyms if defined) | string, int32, int64, double | string_attribute == "beginning of value"...
is_between | Enables inequality matching (<, <=, >=, >) of attribute values | int32, int64, double, date | numeric_attribute >= 10, date_attribute > "2020-01-01"

## Synonym definition

## Excluding attribute intersections

## Example
