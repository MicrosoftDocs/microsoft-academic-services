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
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/histogram?expression={expression}&select={select}&skip={skip}&top={top}&numberOfEntitiesToUse={numberOfEntitiesToUse}
```  

## URI Parameters

Name | In | Required | Type | Description
--- | --- | --- | --- | ---
`expression` | query | Required | string | Structured query expression to evaluate for matching entities used in generating histogram. See [structured query expressions](concepts-query-expressions.md) for documentation.
`numberOfEntitiesToUse` | query | Optional | integer | The number of matching entities to use when calculating histograms. <br/><br/>Defaults to 0, which indicates that all matching entities should be used. <br/><br/>Note that this operation can take a long time to complete for expressions that generate many matching entities.
`select` | query | Optional | string | A list of comma-separated attributes to generate histograms for. See the [entity schema](reference-entity-schema.md) for the attributes that can be requested. If no attributes are specified the response will still include the total number of matching entities. <br/><br/>Defaults to an empty string.
`skip` | query | Optional | integer | The number of histogram values to skip. <br/><br/>Defaults to 0.
`top` | query | Optional | integer | The number of histogram values to return for each attribute. <br/><br/>Defaults to 10.

## Responses

Name | Type | Description
--- | --- | ---
200 OK | [HistogramResponse](#histogramresponse) | Histogram response successfully generated and returned.

## Definitions

| | |
| --- | --- |
[HistogramAttribute](#histogramattribute) | Information for an individual attribute.
[HistogramAttributeValue](#histogramattributevalue) | Information for a distinct attribute value.
[HistogramResponse](#histogramresponse) | Histogram response information.

### HistogramAttribute

Name | Type | Description
--- | --- | ---
attribute | string | The name of the attribute which the histogram was computed from.
totalValueCount | long | Total number of value instances among matching entities for this attribute.
valueDistribution | [HistogramAttributeValue](#histogramattributevalue)[] | Histogram value distribution for this attribute.

### HistogramAttributeValue

Name | Type | Description
--- | --- | ---
numberOfEntities | integer | Number of entities that contain this attribute value.
totalLogProbability | double | Total log probability of entities with this attribute value.
value | string | Distinct value of the attribute.

### HistogramResponse

Name | Type | Description
--- | --- | ---
expressionEvaluated | string | The query expression evaluated to generate matching entities which were used for generating histograms.
histograms | [HistogramAttribute](#histogramattribute)[] | An array of histogram containers.
numberOfEntitiesUsed | integer | The number of matching entities that were used to generate histograms.