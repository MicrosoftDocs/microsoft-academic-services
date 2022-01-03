---
title: LanguageSimilarity Constructor
description: LanguageSimilarity Constructor
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 4/23/2021
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

 LanguageSimilarity(string) Constructor

Namespace: Microsoft.Academic

Assemblies: Microsoft.Academic.LanguageSimilarity.dll

Initializes a new instance of the LanguageSimilarity class.

## LanguageSimilarity(string)

  ```C#
  public LanguageSimilarity(string resourceDir);
  ```

### Parameters

Parameter | Data Type | Description
--- | --- | ---
resourceDir | string | A string specifying the path of the resource directory.

### Examples

  ```C#
  using System;
  using Microsoft.Academic;

  class Test
  {
      static void Main(string[] args)
      {
          // Create an LanguageSimilarity instance and initialize with resources
          string resourceDir = @"..\..\..\resources";
          var ls = new LanguageSimilarity(resourceDir);
      }
  }
  ```
