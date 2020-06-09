---
title: Microsoft Academic Knowledge Exploration Service pricing
description: Provides Azure cost estimator links to model the cost of using Microsoft Academic Knowledge Exploration Service
ms.topic: reference
ms.date: 2020-02-10
---
# Microsoft Academic Knowledge Exploration Service Pricing

MAKES can be hosted on any virtual machine SKU that runs Windows OS. Below are suggested hardware SKU's for various MAKES usage scenarios. These are only *suggested configurations*; you should experiment and determine the most appropriate configuration that best fits your needs.

API Purpose | Description | Host Machine Sku | Cost estimate
--- | --- | --- | ---
Sub-graph access | For enterprise or domain specific solutions that only require a smaller sub-graph of the full Microsoft Academic Graph (MAG). | Standard_DS4_v3  | [Pricing calculator](https://azure.com/e/4a67bc36bc864ed5ac73d4c4724f0886)
Full graph access | Provides moderately fast, responsive API method response times over the entirety of the Microsoft Academic Graph (MAG). |  Standard_D14_v2 | [Pricing calculator](https://azure.com/e/1841c77e64bc44779e25b67a635fae3a)
Fast, full graph access | For production scenarios that require very fast, responsive API method response times over the entirety of the Microsoft Academic Graph (MAG). | Standard_E32_v3 |[Pricing calculator](https://azure.com/e/65f1e82cec54434bbe1894064d074174)

> [!IMPORTANT]
> Price estimates are based on virtual machine instances being online at all times (1 month) and only the most recent MAKES release retained in storage. Use the Azure estimator links above to model different use scenarios, e.g. use hour pricing to simulate only keeping instances online when needed.
