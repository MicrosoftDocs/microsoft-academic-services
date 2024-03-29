---
title: Evaluate method
description: Returns entities that match constraints specified in a structured query expression
ms.topic: reference
ms.date: 2020-02-24
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Evaluate Method

The **evaluate** REST API is used to return a set of academic entities based on a query expression.

**REST endpoint:**

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/evaluate? 
```   

## Request Parameters  

Name | Value | Required? | Description
--- | --- | --- | ---
**subscription-key** | String | Yes | Valid Project Academic Knowledge subscription key
**expr** | Text string | Yes | A query expression that specifies which entities should be returned.
**model** | Text string | No | Name of the model that you wish to query.  Currently, the value defaults to *latest*.
**attributes** | Text string | No<br>default: Id | A comma-delimited list that specifies the attribute values that are included in the response. Attribute names are case-sensitive.
**count** | Number | No<br>Default: 10 | Number of results to return.
**offset** | Number |	No<br>Default: 0	| Index of the first result to return.
**orderby** |	Text string | No<br>Default: by decreasing prob	| Name of an attribute that is used for sorting the entities. Optionally, ascending/descending can be specified. The format is: *name:asc* or *name:desc*.

## Response (JSON)

Name | Description
--- | ---   
**expr** | The *expr* parameter from the request.
**entities** | An array of 0 or more entities that matched the query expression. Each entity contains a natural log probability value and the values of other requested attributes.
**aborted** | True if the request timed out.

### Example

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/evaluate?expr=
Composite(AA.AuN=='jaime teevan')&count=2&attributes=Ti,Y,CC,AA.AuN,AA.AuId&subscription-key=<subscription_key>
```

Typically, an expression will be obtained from a response to the **interpret** method.  But you can also compose query expressions yourself (see [Query Expression Syntax](reference-query-expression-syntax.md)).  
  
Using the *count* and *offset* parameters, a large number of results may be obtained without sending a single request that results in a huge (and potentially slow) response.  In this example, the request used the expression for the first interpretation from the **interpret** API response as the *expr* value. The *count=2* parameter specifies that 2 entity results are being requested. And the *attributes=Ti,Y,CC,AA.AuN,AA.AuId* parameter indicates that the title, year, citation count, author name, and author ID are requested for each result.  See [Entity Attributes](reference-entity-attributes.md) for a list of attributes.
  
``` JSON
{
  "expr": "Composite(AA.AuN=='jaime teevan')",
  "entities": 
  [
    {
      "logprob": -15.08,
      "Ti": "personalizing search via automated analysis of interests and activities",
      "Y": 2005,
      "CC": 372,
      "AA": [
        {
          "AuN": "jaime teevan",
          "AuId": 1968481722
        },
        {
          "AuN": "susan t dumais",
          "AuId": 676500258
        },
        {
          "AuN": "eric horvitz",
          "AuId": 1470530979
        }
      ]
    },
    {
      "logprob": -15.389,
      "Ti": "the perfect search engine is not enough a study of orienteering behavior in directed search",
      "Y": 2004,
      "CC": 237,
      "AA": [
        {
          "AuN": "jaime teevan",
          "AuId": 1982462162
        },
        {
          "AuN": "christine alvarado",
          "AuId": 2163512453
        },
        {
          "AuN": "mark s ackerman",
          "AuId": 2055132526
        },
        {
          "AuN": "david r karger",
          "AuId": 2012534293
        }
      ]
    }
  ]
}
```
