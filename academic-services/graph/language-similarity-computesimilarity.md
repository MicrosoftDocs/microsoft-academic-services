---
title: LanguageSimilarity.ComputeSimilarity Method
description: LanguageSimilarity.ComputeSimilarity Method
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# LanguageSimilarity.ComputeSimilarity Method

Namespace: Microsoft.Academic

Assemblies: Microsoft.Academic.LanguageSimilarity.dll

### Compute similarity score between 2 strings or between a string and a concept.

## Overloads

---
`ComputeSimilarity(String, String)`: Compute Similarity score between 2 strings

---
`ComputeSimilarity(String, long)`: Compute Similarity score between a string and a concept

## ComputeSimilarity(String, String)

Compute Similarity score between 2 strings.

  ```C#
  public static float ComputeSimilarity(string text1, string text2);
  ```

**Parameters**

Name | Data Type | Note
--- | --- | ---
text1 | string | 
text2 | string | 

**Examples**

  ```C#
  using System;
  using Microsoft.Academic;

  class Test
  {
      static void Main(string[] args)
      {
          // Create an LanguageSimilarity instance and initialize with resources
          string resourceDir = @"..\..\..\resources";
          var languageSimilarity = new LanguageSimilarity(resourceDir);

          // Call ComputeSimilarity to compute similarity between 2 strings
          string text1 = "A speech understanding system includes a language model";
          string text2 = "The language model stores information related to words and semantic information";
          var score = languageSimilarity.ComputeSimilarity(text1, text2);
          Console.WriteLine(score);
      }
  }
  ```

## ComputeSimilarity(String, long)

Compute Similarity score between a string and a concept

   ```C#
   public static float ComputeSimilarity(string text, long fieldOfStudyId);
   ```

**Parameters**

Name | Data Type | Note
--- | --- | ---
text | string | 
fieldOfStudyId | long | 

**Examples**

  ```C#
  using System;
  using Microsoft.Academic;

  class Test
  {
      static void Main(string[] args)
      {
          // Create an LanguageSimilarity instance and initialize with resources
          string resourceDir = @"..\..\..\resources";
          var languageSimilarity = new LanguageSimilarity(resourceDir);

          // Call ComputeSimilarity to compute similarity between a string and a concept
          string text = "A speech understanding system includes a language model";
          long fosid = 137293760; // language model
          var score = languageSimilarity.ComputeSimilarity(text, fosid);
          Console.WriteLine(score);
      }
  }
  ```
