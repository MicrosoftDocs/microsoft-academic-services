---
title: GetTopFieldsOfStudy
description: GetTopFieldsOfStudy
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/22/2019
---
# GetTopFieldsOfStudy Method

Get top fields of study related to a string

   ```C#
   public static IEnumerable<Tuple<long,float>> GetTopFieldsOfStudy(string text, int maxCount=100, int minScore=0);
   ```

**Parameters**

Parameter | Data Type | Note
--- | --- | ---
text | string | 
maxCount | int | 
minScore | float | 

**Examples**

   ```C#
   public static IEnumerable<Tuple<long,float>> GetTopFieldsOfStudy(string text, int maxCount=100, int minScore=0);
   ```