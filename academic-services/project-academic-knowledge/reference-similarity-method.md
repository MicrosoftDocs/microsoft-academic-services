---
title: Similarity method
description: Calculate the cosine similarity of two strings
ms.topic: reference
ms.date: 2020-02-24
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Similarity Method

The **similarity** REST API is used to calculate the cosine similarity between two strings.

**REST endpoint:**

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/similarity?
```

## Request Parameters

Parameter | Data Type | Required | Description
--- | --- | --- | ---
**subscription-key** | String | Yes | Valid Project Academic Knowledge subscription key
**s1** | String | Yes | String* to be compared
**s2** | String | Yes | String* to be compared

<sub>
*Strings to compare have a maximum length of 1MB.
</sub>

## Response

Name | Description
--- | ---
**SimilarityScore** | A floating point value representing the cosine similarity of s1 and s2, with values closer to 1.0 meaning more similar and values closer to -1.0 meaning less

## Success/Error Conditions

HTTP Status | Reason | Response
--- | --- | ---
**200** | Success | Floating point number
**400** | Bad request or request invalid | Error message
**500** | Internal server error | Error message
**Timed out** | Request timed out. | Error message

## Example: Calculate similarity of two partial abstracts

### Request

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/similarity?subscription-key=<subscription_key>&s1=Using complementary priors, we derive a fast greedy algorithm that can learn deep directed belief networks one layer at a time, provided the top two layers form an undirected associative memory
&s2=Deepneural nets with a large number of parameters are very powerful machine learning systems. However, overfitting is a serious problem in such networks
```

In this example, we generate the similarity score between two partial abstracts using the **similarity** API.

### Response

``` HTTP
0.520
```

### Remarks

The similarity score is determined by assessing the academic concepts through word embedding. In this example, 0.52 means that the two partial abstracts are somewhat similar.
