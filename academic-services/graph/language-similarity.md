---
title: Language Similarity Package
description: Using Language Similarity Package
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# Language Similarity Package

Language Similarity Package is a package for understanding document semantics. We put together  pre-trained models and concept-tagging algorithms as a software package that executes in the end user’s environment. Users can also tag, compare, and rebuild concept hierarchies based on any private corpus.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Setting up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

* Request Language Similarity Package when requesting MAG.

  > [!NOTE]
  > Language Similarity Package is not included in basic MAG distribution. Please ask for Language Similarity Package otherwise it will not be included in the MAG distribution.

## Contents

The LanguageSimilarity package is distributed as a single .zip file. It includes the algorithms, wrapped in dlls and a binary resource directory containing the pre‑trained models. After unzipping the package, users will see a folder structure as shown in the figure below. README.md and README.txt contain the general information about the package, system requirements, and API signature definitions.

  ![Language Similarity Package content](media/language-similarity/content.png "Language Similarity Package content")

We include a C# demo project in the LanguageSimilarityExample folder that also has the file sample.txt as the sample input for the demo, where each line contains the parameter(s) for an API call.
The demo is a console program that reads in the resource file directory and the path of the sample.txt file to initialize the LanguageSimilarity model.

## Methods

* [ComputeSimilarity](language-similarity-computesimilarity.md)
* [GetTopFieldsOfStudy](language-similarity-gettopfieldsofstudy.md)

## Resources

* [Get started with Azure Data Lake Analytics using Azure portal](https://docs.microsoft.com/en-us/azure/data-lake-analytics/data-lake-analytics-get-started-portal)
