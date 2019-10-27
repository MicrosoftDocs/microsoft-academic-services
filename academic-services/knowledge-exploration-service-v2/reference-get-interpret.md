---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Interpret REST API

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/interpret?query={query}
```  

With optional parameters:

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/interpret?query={query}&top={top}&skip={skip}&timeout={timeout}&allowCompletions={allowCompletions}&topEntitiesPerInterpretation={topEntitiesPerInterpretation}&select={select}
```  

## URI Parameters

Name | In | Required | Type | Description
--- | --- | --- | --- | ---
`query` | query | Required | string | The natural language query to generate interpretations for. See the [natural language queries](concepts-queries.md) page for more details.
`top` | query | Optional | integer | The number of interpretations to generate in the result set. Defaults to 5.
`skip` | query | Optional | integer | The number of interpretations to skip in the result set. Defaults to 0.
`timeout` | query | Optional | integer | The maximum amount of time in milliseconds to use when generating interpretations. Defaults to 2000. <br/><br/>If the timeout is hit, all interpretations that have been generated will be returned and a "timedOut" flag will be set in the response indicating that the timeout was hit before the total number of requested interpretations was met.
`allowCompletions` | query | Optional | boolean | Indicates if interpretations should be generated that infer entity attribute values beyond what was provided in the query. <br/><br/>For example, the for query "microsoft machine le", if `allowCompletions` is set to true an interpretation could be generated that completes "le" to "learning", i.e. "microsoft machine learning". <br/><br/>Defaults to false.
`topEntitiesPerInterpretation` | query | Optional | integer | The number of entities that should be returned for each interpretation that match the interpretted query expression.
`select` | query | Optional | string | A list of comma-separated attributes to include for each entity returned for each interpretation. See the [entity schema overview](reference-entity-schema.md#entity-types) for the attributes that can be requested. If no attributes are specified then the each entity will only contain its corresponding score.
`normalizeQuery` | query | Optional | boolean | Indicates if the query should have normalization rules applied to it before being interpreted. See the [entity schema overview](reference-entity-schema.md#normalization-rules) for documentation on the normalization rules that are applied to indexed string fields. <br/><br/>Defaults to false.

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
