---
title: Deprecation of Extended Entity Attribute
description: Information about the deprecation of the Extended Entity Attribute and guidance for migration
ms.topic: reference
ms.date: 07/30/2020
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Deprecation of Entity Extended Attribute

The Extended Entity Attribute has been deprecated and legacy application support will officially end on December 21, 2020.

This means that the Extended attribute will no longer be able to be requested from the API, and doing so will result in an "attribute not found" error.

All sub-attributes previously available as part of the Extended attribute have been moved to the top-level of the schema with the following mapping:

Friendly name | Extended sub-attribute | New top-level attribute
--- | --- | ---
BibTex document type | E.BT | BT
BibTex venue name | E.BV | BV
Citation contexts | E.CC | CitCon
Display name | E.DN | DN
Digital Object Identifier | E.DOI | DOI
First page of publication | E.FP | FP 
Journal issue | E.I | I
Inverted Abstract | E.IA | IA
Last page of publication | E.LP | LP
Publisher | E.PB | PB 
Sources | E.S | S
Volume | E.V | V
Venue full name | E.VFN | VFN
Venue short name | E.VSN | VSN
Last known affiliation ID | E.LKA.AfId | LKA.AfId
Last known affiliation name | E.LKA.AfN | LKA.AfN
Paper count | E.PC | PC
Full name | E.FN | FN


## Migration Considerations

If your application depends on Extended Entity Attribute, you'll have the migrate your application before December 21, 2020. You can migrate your application by changing the Evaluate/Histogram API requests construction and response handling.

### Evaluate/Histogram API requests

You'll have to request each extended attributes explicitly. You can find the equivalent attributes in the [Entity Attribute Reference](./reference-entity-attributes.md)

For example, considering the following Evaluate request to get all papers ID, title, and extended attributes from 2020:

```JSON
 {
    "attributes" : "Id, Ti, E",
    "expr" : "And(Y=2020, Ty='0')"
 }
```

Should be changed to the following:

```JSON
 {
    "attributes" : "Id, Ti, BT, BV, CitCon, DN, DOI, FP, I, IA, LP, PB, S, V, VFN, VSN",
    "expr" : "And(Y=2020, Ty='0')"
 }
```

### Evaluate/Histogram API responses

After migrating your Evaluate and Histogram requests, you'll need to ensure your application can handle the new response correctly.
