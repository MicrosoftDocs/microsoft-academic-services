---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Histogram REST API

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
`select` | query | Optional | string | <br/><br/>Defaults to an empty string.
`skip` | query | Optional | string | The number of matching entities to skip in the result set. <br/><br/>Defaults to 0.
`top` | query | Optional | string | <br/><br/>Defaults to 10.
`select` | query | Optional | string | 
`select` | query | Optional | string | 
`select` | query | Optional | string | 

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
