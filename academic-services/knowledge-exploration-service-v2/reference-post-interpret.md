---
title: 
description: 
ms.topic: reference
ms.date: 
---

# Interpret REST API

The **Interpret** method generates semantic interpretations of a natural language query based on the combination of a language grammar and indexed attributes.

It can be used as either a way of interpreting a specific natural language query, or to generate natural language query suggestions using the original query as a stem.

For full details on the language grammar see the [natural language queries](concepts-queries.md) page.

``` HTTP
POST http://{serviceName}.{serviceRegion}.cloudapp.azure.com/interpret
```  

## Request Body

Name | Required | Type | Description
--- | --- | --- | ---
query | Required | string | The natural language query to generate interpretations for. See the [natural language queries](concepts-queries.md) page for more details.
options | Optional | [InterpretRequestOptions](#interpretrequestoptions) | Configuration parameters for interpret request

## Responses

Name | Type | Description
--- | --- | ---
200 OK | [InterpretResponse](#interpretresponse) | Interpret response successfully generated and returned.

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

| | |
| --- | --- |
[InterpretRequestOptions](#interpretrequestoptions) | Optional configuration parameters for histogram request.
[InterpretResponse](#interpretresponse) | Interpret response information.
[Interpretation](#interpretation) | Information for an individual query interpretation.

### InterpretRequestOptions

Name | Type | Description
--- | --- | ---
`allowCompletions` | boolean | Indicates if interpretations should be generated that infer entity attribute values beyond what was provided in the query. <br/><br/>For example, the for query "microsoft machine le", if `allowCompletions` is set to true an interpretation could be generated that completes "le" to "learning", i.e. "microsoft machine learning". <br/><br/>Defaults to false.
`normalizeQuery` | boolean | Indicates if the query should have normalization rules applied to it before being interpreted. See the [entity schema overview](reference-entity-schema.md#normalization-rules) for documentation on the normalization rules that are applied to indexed string fields. <br/><br/>Defaults to false.
`select` | string | A list of comma-separated attributes to include for each entity returned for each interpretation. See the [entity schema overview](reference-entity-schema.md#entity-types) for the attributes that can be requested. <br/><br/>If no attributes are specified then the each entity will only contain its corresponding score. <br/><br/>If an asterisk (*) is specified, all available attributes will be returned. <br/><br/>Defaults to an empty string.
`skip` | integer | The number of interpretations to skip in the result set. <br/><br/>Defaults to 0.
`timeout` | integer | The maximum amount of time in milliseconds to use when generating interpretations. <br/><br/>If the timeout is hit, all interpretations that have been generated will be returned and a "timedOut" flag will be set in the response indicating that the timeout was hit before the total number of requested interpretations was met. <br/><br/>Defaults to 2000.
`top` | integer | The number of interpretations to generate in the result set. <br/><br/>Defaults to 5.
`topEntitiesPerInterpretation` | integer | The number of entities that should be returned for each interpretation that match the interpreted query expression. <br/><br/>Defaults to 0.

### InterpretResponse

Name | Type | Description
--- | --- | ---
interpretations | [Interpretation](#interpretation)[] | Array of interpretations ordered by relevance.
numberOfTimedOutPartitions | integer | The number of index partitions that timed out before returning the requested number of interpretations.
query | string | The natural language query used to generate interpretations.

### Interpretation

Name | Type | Description
--- | --- | ---
queryExpression | string | The structured query expression that represents the semantic parse interpreted from the natural language query. See [structured query expressions](concepts-query-expressions.md) for documentation.
score | double | The semantic score associated with the interpretation. See the [natural language queries](concepts-queries.md) page for more details.
semanticParse | string | The semantic parse of the natural language query. See the [natural language queries](concepts-queries.md) page for more details.
topEntities | json[] | Array of JSON objects representing the entities matching the structured query expression for this interpretation. Each object will contain the attributes requested in `select` if available.

## See also
