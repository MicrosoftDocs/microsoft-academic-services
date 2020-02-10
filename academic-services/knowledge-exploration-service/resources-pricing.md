---
title: Microsoft Academic Knowledge Exploration Service pricing
description: Provides Azure cost estimator links to model the cost of using Microsoft Academic Knowledge Exploration Service
ms.topic: reference
ms.date: 2020-02-10
---
# Microsoft Academic Knowledge Exploration Service pricing

Below are different solutions and their azure cost for using Microsoft Academic Knowledge Exploration Service(MAKES). These are example environment setups, you should test and pick a environment setup that best fits your needs.

API Purpose | Description |Host Machine Sku | Cost estimate
--- | --- | --- | ---
Development | For fast iterative development over all knowledge in Microsoft Academic Graph(MAG). |  Standard_DS14_v2 | [Pricing calculator](https://azure.com/e/9bfe795705424b26a118639a198adfbd)
Production (Small) | For enterprise or domain specific solutions that uses a sub-graph of Microsoft Academic Graph(MAG). | Standard_DS4_v3  | [Pricing calculator](https://azure.com/e/c04290edd8bf4db08ba23db8392430c4)
Production (Large) | For large scale service over all knowledge in Microsoft Academic Graph(MAG).  | Standard_E32s_v3 |[Pricing calculator](https://azure.com/e/2c1ee1b19db84b7dbb6d3eb7b5492d6c)

> [!IMPORTANT]
> \* Price estimates are based on virtual machine instances being online at all times (1 month) and only the most two recent version of the ma retained in storage. Use the Azure estimator links above to model different use scenarios, e.g. use hour pricing to simulate only keeping instances online when needed.
