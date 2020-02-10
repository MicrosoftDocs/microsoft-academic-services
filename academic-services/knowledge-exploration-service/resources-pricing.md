---
title: Microsoft Academic Knowledge Exploration Service pricing
description: Provides Azure cost estimator links to model the cost of using Microsoft Academic Knowledge Exploration Service
ms.topic: reference
ms.date: 2020-02-10
---
# Microsoft Academic Knowledge Exploration Service pricing

Below are suggested hardware SKU's for various MAKES usage scenarios. These are only *suggested configurations*; you should experiment and determine the most appropriate configuration that best fits your needs.

API Purpose | Description | Host Machine Sku | Cost estimate
--- | --- | --- | ---
Full graph access | Provides moderately fast, responsive API method response times over the entirety of the Microsoft Academic Graph (MAG). |  Standard_DS14_v2 | [Pricing calculator](https://azure.com/e/9bfe795705424b26a118639a198adfbd)
Sub-graph access | For enterprise or domain specific solutions that only require a smaller sub-graph of the full Microsoft Academic Graph (MAG). | Standard_DS4_v3  | [Pricing calculator](https://azure.com/e/c04290edd8bf4db08ba23db8392430c4)
Fast, full graph access | For production scenarios that require very fast, responsive API method response times over the entirety of the Microsoft Academic Graph (MAG).  | Standard_E32s_v3 |[Pricing calculator](https://azure.com/e/2c1ee1b19db84b7dbb6d3eb7b5492d6c)

> [!IMPORTANT]
> \* Price estimates are based on virtual machine instances being online at all times (1 month) and only the most two recent version of the ma retained in storage. Use the Azure estimator links above to model different use scenarios, e.g. use hour pricing to simulate only keeping instances online when needed.
