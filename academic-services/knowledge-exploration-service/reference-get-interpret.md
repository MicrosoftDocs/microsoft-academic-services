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
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/interpret?query={query}
```  

With optional parameters:

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/interpret?query={query}&count={count}&offset={offset}&timeout={timeout}&complete={complete}&entityCount={entityCount}&attributes={attributes}
```  

## URI Parameters

Name | Required | Type | Description
--- | --- | --- | ---
`query` | Required | string | The natural language query to generate interpretations for. See the [natural language queries](concepts-queries.md) page for more details.
`count` | Optional | integer | The number of interpretations to generate in the result set. <br/><br/>Defaults to 5.
`complete` | Optional | integer | Value of 1 indicates that interpretations should be generated that infer entity attribute values beyond what was provided in the query. <br/><br/>For example, the for query "microsoft machine le", if `complete` is set to true an interpretation could be generated that completes "le" to "learning", i.e. "microsoft machine learning". Value of 0 indicates that no inference is made and only the exact query text provided is matched. <br/><br/>Defaults to 1.
`normalize` | Optional | integer | Value of 1 indicates that the query should have normalization rules applied to it before being interpreted. See the [entity schema overview](reference-entity-schema.md#normalization-rules) for documentation on the normalization rules that are applied to indexed string fields. <br/><br/>Defaults to 1.
`offset` | Optional | integer | The number of interpretations to skip in the result set. <br/><br/>Defaults to 0.
`timeout` | Optional | integer | The maximum amount of time in milliseconds to use when generating interpretations. <br/><br/>If the timeout is hit, all interpretations that have been generated will be returned and a "timedOut" flag will be set in the response indicating that the timeout was hit before the total number of requested interpretations was met. <br/><br/>Defaults to 2000.
`entityCount` | Optional | integer | The number of entities that should be returned for each interpretation that match the interpreted query expression. <br/><br/>Defaults to 0.
`attributes` | Optional | string | A list of comma-separated attributes to include for each entity returned for each interpretation. See the [entity schema overview](reference-entity-schema.md#entity-types) for the attributes that can be requested. <br/><br/>If no attributes are specified then the each entity will only contain its corresponding score. <br/><br/>If an asterisk (*) is specified, all available attributes will be returned. <br/><br/>Defaults to an empty string.

## Responses

Name | Type | Description
--- | --- | ---
200 OK | [InterpretResponse](#interpretresponse) | Interpret response successfully generated and returned.

## Definitions

| | |
| --- | --- |
[InterpretResponse](#interpretresponse) | Interpret response information.
[Interpretation](#interpretation) | Information for an individual query interpretation.
[InterpretationRuleMatch](#interpretationrulematch) | Information returned for grammar rules matched during interpretation.
[InterpretationRuleMatchOutput](#interpretationrulematchoutput) | Output generated for a grammar rule match.

### InterpretResponse

Name | Type | Description
--- | --- | ---
interpretations | [Interpretation](#interpretation)[] | Array of interpretations ordered by relevance.
timed_out_count | integer | The number of index partitions that timed out before returning the requested number of interpretations.
string | The natural language query used to generate interpretations.

### Interpretation

Name | Type | Description
--- | --- | ---
logprob | double | The semantic score associated with the interpretation. See the [natural language queries](concepts-queries.md) page for more details.
parse | string | The semantic parse of the natural language query. See the [natural language queries](concepts-queries.md) page for more details.
rules | [InterpretationRuleMatch](#interpretationrulematch)[] | Array of grammar rules matched when generating interpretation.

### InterpretationRuleMatch

Name | Type | Description
--- | --- | ---
name | string | The name of the matching rule. For the default grammar this will always be "#GetPapers".
outuput | [InterpretationRuleMatchOutput](#interpretationrulematchoutput)

### InterpretationRuleMatchOutput

Name | Type | Description
--- | --- | ---
type | string | The type of output generated by the rule match. For the default grammar this will always be "query", meaning a query expression is generated for each interpretation.
value | string | The structured query expression that represents the semantic parse interpreted from the natural language query. See [structured query expressions](concepts-query-expressions.md) for documentation.
entities | json[] | Array of JSON objects representing the entities matching the structured query expression for this interpretation. Each object will contain the attributes requested in `attributes` if available.
