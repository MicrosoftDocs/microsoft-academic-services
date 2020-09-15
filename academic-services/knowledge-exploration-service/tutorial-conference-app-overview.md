---
title: Conference Knowledge Application Tutorial Overview
description: Overiview for a series of tutorials that leverage MAKES to build a conference knowledge application
ms.topic: tutorial
ms.date: 2020-09-14
---
# Conference Knowledge Application Tutorial

This tutorial walks users through building a KDD Conference application using MAKES.

User of the conference application should be able to find relatevent KDD papers and presentation time slots through auto-suggest, search, and filters.

This tutorial is split into four sections to illustrate different concepts. 

1. Create Filterable Paper List
	- Learn how to design a MAKES index schema
		- Know what are the appropriate attribute types to use 
		- Understand the role of index operations
    - Build and test index with kesm local dev tools
	- Craft KES query expressions
		- Create constraint queries using ‘And()’ and ‘=’ operator
	- Retrieve data using Evaluate API
	- Create filters using Histogram API

1. Add Semantic and Keyword Search
	- Learn how to design a MAKES grammar for search
	- Create search and auto-suggest using Interpret API

1. Link and Add Conference Oral Presentation Data
	- Learn how to link private data with entities in MAKES index(es)

1. Customize Search for Oral Presentataion 
    - Learn how to design a MAKES index schema to store different multiple types of entities
	- Create search and auto-suggest using Interpret API