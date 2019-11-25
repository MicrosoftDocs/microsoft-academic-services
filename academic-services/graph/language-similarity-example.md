---
title: Language Similarity Example
description: Language Similarity Example
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# Language Similarity Example

### Get top fields of study related to a string

  ```C#
  public static IEnumerable<Tuple<long,float>> GetTopFieldsOfStudy(string text, int maxCount=100, int minScore=0);
  ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text | string | 
maxCount | int | default 100
minScore | float | default 0

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

          // Call GetTopFieldsOfStudy to get top concepts related to a string
          string text = "A speech understanding system includes a language model";
          var foses = languageSimilarity.GetTopFieldsOfStudy(text);
          foreach (var fos in foses)
          {
              Console.WriteLine("{0}\t{1}", fos.Item1, Math.Round(fos.Item2, 4));
          }
      }
  }
  ```

**Example Output**

  ```
  137293760       0.6154
  204321447       0.4416
  28490314        0.437
  107457646       0.4348
  188147891       0.4346
  41895202        0.4304
  41008148        0.4148
  15744967        0.3746
  144024400       0.3583
  ```
