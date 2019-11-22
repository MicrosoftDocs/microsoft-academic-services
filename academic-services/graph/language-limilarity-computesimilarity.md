---
title: ComputeSimilarity
description: ComputeSimilarity
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# ComputeSimilarity Method

Compute similarity score between a string and another string or a concept

## Overloads

--- | ---
ComputeSimilarity(String, String) | Compute Similarity score between 2 strings
ComputeSimilarity(String, long) | Compute Similarity score between a string and a concept

## ComputeSimilarity(String, String)

Compute Similarity score between 2 strings.

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text1 | string | 
text2 | string | 

**Examples**

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```

## ComputeSimilarity(String, long)

Compute Similarity score between a string and a concept

   ```C#
   public static float ComputeSimilarity(string text, long fieldOfStudyId);
   ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text | string | 
fieldOfStudyId | long | 

**Examples**

   ```C#
   public static float ComputeSimilarity(string text1, string text2);
   ```
