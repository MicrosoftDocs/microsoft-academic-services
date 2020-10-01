---
title: LanguageSimilarity.ComputeSimilarity Method
description: LanguageSimilarity.ComputeSimilarity Method
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 09/23/2020
---
# LanguageSimilarity.ComputeSimilarity Method

Namespace: Microsoft.Academic

Assemblies: Microsoft.Academic.LanguageSimilarity.dll

### Compute the similarity score between 2 strings or between a string and a concept.

## Overloads

---
[ComputeSimilarity(String, String)](#computesimilaritystring-string) Returns a similarity score between two strings.


---
[ComputeSimilarity(String, long)](#computesimilaritystring-long) Returns a similarity score between a string and a field of study id.

## ComputeSimilarity(String, String)

Returns a similarity score between two strings. Score returned is between [-1, 1], with larger number representing higher similarity.

  ```C#
  public float ComputeSimilarity(string text1, string text2);
  ```

**Parameters**

Name | Data Type | Description
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
          var ls = new LanguageSimilarity(resourceDir);

          // Call ComputeSimilarity to get similarity score between 2 strings
          string text1 = "A speech understanding system includes a language model";
          string text2 = "The language model stores information related to words and semantic information";
          var score = ls.ComputeSimilarity(text1, text2);
          Console.WriteLine(score);
      }
  }
  ```

**Output**

  > 0.7053913

## ComputeSimilarity(String, long)

Returns a similarity score between a string and a field of study id. Score returned is between [-1, 1], with larger number representing higher similarity.

   ```C#
   public float ComputeSimilarity(string text, long fieldOfStudyId);
   ```

**Parameters**

Name | Data Type | Description
--- | --- | ---
text | string |
fieldOfStudyId | long | A field of study id defined in MAG

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
          var ls = new LanguageSimilarity(resourceDir);

          // Call ComputeSimilarity to get similarity score between a string and a concept
          string text = "A speech understanding system includes a language model";
          long fosid = 137293760; // language model
          var score = ls.ComputeSimilarity(text, fosid);
          Console.WriteLine(score);
      }
  }
  ```

**Output**

  > 0.615355
