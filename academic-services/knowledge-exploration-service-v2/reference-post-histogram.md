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
POST http://{serviceName}.{serviceRegion}.cloudapp.azure.com/histogram
```  

## Request Body

Name | Required | Type | Description
--- | --- | --- | ---
expression | Required | string | Structured query expression to evaluate for matching entities used in generating histogram. See [structured query expressions](concepts-query-expressions.md) for documentation.
options | Optional | [HistogramRequestOptions](#histogramrequestoptions) | Configuration parameters for histogram request

## Responses

Name | Type | Description
--- | --- | ---
200 OK | [HistogramResponse](#histogramresponse) | Histogram response successfully generated.

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
[HistogramAttribute](#histogramattribute) | Information for an individual attribute
[HistogramAttributeValue](#histogramattributevalue) | Information for a distinct attribute value
[HistogramRequestOptions](#histogramrequestoptions) | Optional configuration parameters for histogram request
[HistogramResponse](#histogramresponse) | Histogram response information

### HistogramAttribute

Name | Type | Description
--- | --- | ---
attribute | string | The name of the attribute which the histogram was computed from
totalValueCount | long | Total number of value instances among matching entities for this attribute
valueDistribution | [HistogramAttributeValue](#histogramattributevalue)[] | Histogram value distribution for this attribute

### HistogramAttributeValue

Name | Type | Description
--- | --- | ---
numberOfEntities | integer | Number of entities that contain this attribute value
totalLogProbability | double | Total log probability of entities with this attribute value
value | string | Distinct value of the attribute

### HistogramRequestOptions

Name | Type | Description
--- | --- | ---
`numberOfEntitiesToUse` | integer | The number of matching entities to use when calculating histograms. <br/><br/>Defaults to 0, which indicates that all matching entities should be used. <br/><br/>Note that this operation can take a long time to complete for expressions that generate many matching entities.
`select` | string | A list of comma-separated attributes to generate histograms for. See the [entity schema](reference-entity-schema.md) for the attributes that can be requested. If no attributes are specified the response will still include the total number of matching entities. <br/><br/>Defaults to an empty string.
`skip` | integer | The number of histogram values to skip. <br/><br/>Defaults to 0.
`top` | integer | The number of histogram values to return for each attribute. <br/><br/>Defaults to 10.

### HistogramResponse

Name | Type | Description
--- | --- | ---
expressionEvaluated | string | The query expression evaluated to generate matching entities which were used for generating histograms
histograms | [HistogramAttribute](#histogramattribute)[] | An array of histogram containers
numberOfEntitiesUsed | integer | The number of matching entities that were used to generate histograms

## See also
