---
title: Language Similarity Package
description: Using Language Similarity Package
services: microsoft-academic-services
ms.topic: conceptual
ms.service: microsoft-academic-services
ms.date: 3/23/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Language Similarity Package

The Microsoft Academic Language Similarity Package provides supplementary processing functionality for use with the Microsoft Academic Graph (MAG). This package includes Language Similarity API and required resources. This API provides functionality for:

* Similarity comparison between input texts using pre-trained word embeddings which are trained on the MAG corpus, and
* Labeling text with fields of study defined in MAG.

## Prerequisites

Before running these examples, you need to complete the following setups:

* Set up provisioning of Microsoft Academic Graph to an Azure blob storage account. See [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md).

## System Requirements

* Microsoft Windows 7 (or above) 64-bit OS
* .NET Framework version 4.5.2+
* Visual Studio 2015 (or above)

## Contents

The Language Similarity package is distributed as a single zip file. It is located at **`nlp\LanguageSimilarity.zip`** in the MAG container.

  ![LanguageSimilarity.zip](media/language-similarity/zip.png "LanguageSimilarity.zip")

It includes algorithms in dlls and resources with pre‑trained models. After unzipping the package, users will see a folder structure as shown in the figure below. README files contain general information about the package, system requirements, and API signatures.

  ![Language Similarity Package content](media/language-similarity/content.png "Language Similarity Package content")

We also include a C# demo project in the LanguageSimilarityExample folder. It contains sample.txt as input for the demo project.
The demo project is a console program which takes resource directory and the sample.txt path as paremeters. The resource directory is to initialize the language similarity models, while sample.txt is used to provide prarmeters for calling methods in this package.

## Constructor

* [LanguageSimilarity(String)](language-similarity-constructor.md)

## Methods

* [ComputeSimilarity](language-similarity-computesimilarity.md)
* [GetTopFieldsOfStudy](language-similarity-gettopfieldsofstudy.md)

## Sample

* [Language Similarity Sample (C#)](language-similarity-example.md)

## Resource

* [Get Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
