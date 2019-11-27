---
title: LanguageSimilarity.GetTopFieldsOfStudy Method
description: LanguageSimilarity.GetTopFieldsOfStudy Method
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/27/2019
---
# LanguageSimilarity.GetTopFieldsOfStudy Method

Namespace: Microsoft.Academic

Assemblies: Microsoft.Academic.LanguageSimilarity.dll

### Takes in a string and labels it with fields of study available in MAG. Returns a list of tuples of type (long, float), where the first value in the tuple being the labeled field of study id and the second value being the similarity score.

  ```C#
  public IEnumerable<Tuple<long,float>> GetTopFieldsOfStudy(string text, int maxCount=100, int minScore=0);
  ```

**Parameters**

Parameter | Data Type | Description
--- | --- | ---
text | string | The string to label with fields of study.
maxCount | int | Default 100. The maximum number of fields of study to return.
minScore | float | Default 0. A minimum similarity score threshold. Fields of study with similarity scores less than `minScore` will not be in the returned list.

**Return value**

Returns a IEnumerable of `Tuple<long,float>`. The first item is a field of study id defined in MAG. The second item is the similarity score between the input string and the field of study.

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

          // Call GetTopFieldsOfStudy to get top concepts related to a string
          string text = "A speech understanding system includes a language model";
          var foses = ls.GetTopFieldsOfStudy(text);
          foreach (var fos in foses)
          {
              Console.WriteLine("{0}\t{1}", fos.Item1, Math.Round(fos.Item2, 4));
          }
      }
  }
  ```

**Output**

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
