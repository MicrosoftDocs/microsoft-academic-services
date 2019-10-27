---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Histogram REST API

The **Histogram** method computes the entities matching a structured query expression and then calculates the distribution of the requested attributes values in the matched entities.

This method is useful for determining the most dominant attribute values in a result set, e.g. finding the most dominant conference Microsoft publishes in (see [examples](#examples) section below).

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/histogram?expression={expression}
```  

With optional parameters:

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/histogram?expression={expression}
```  

## URI Parameters

Name | In | Required | Type | Description
--- | --- | --- | --- | ---
`expression` | query | Required | string | Structured query expression to evaluate. See [structured query expressions](concepts-query-expressions.md) for documentation.
`select` | query | Optional | string | A list of comma-separated attributes to generate histograms for. See the [entity schema](reference-entity-schema.md) for the attributes that can be requested. If no attributes are specified the response will still include the total number of matching entities. <br/><br/>Defaults to an empty string.
`skip` | query | Optional | integer | The number of histogram values to skip. <br/><br/>Defaults to 0.
`top` | query | Optional | integer | The number of histogram values to return for each attribute. <br/><br/>Defaults to 10.
`numberOfEntitiesToUse` | query | Optional | integer | The number of matching entities to use when calculating histograms. <br/><br/>Defaults to 0, which indicates that all matching entities should be used. <br/><br/>Note that this operation can take a long time to complete for expressions that generate many matching entities.

## Request Body

Name | Required | Type | Description
--- | --- | --- | ---

## Responses

Name | Type | Description
--- | --- | ---

## Examples

### Example name

Example description

#### Sample Request

``` HTTP
GET|POST http://example.com
```

Request Body

``` JSON
{
    "Sample": "Request"
}
```

#### Sample Response

Status code: XXX

``` JSON
{
    "Sample": "Response"
}
```

## Definitions

Name | Type | Description
--- | --- | ---

## See also
