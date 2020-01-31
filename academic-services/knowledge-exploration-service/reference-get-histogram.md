---
title: GET Histogram
description: Computes attribute value distribution for a structured query expression
ms.topic: reference
ms.date: 2020-02-07
---

# Histogram REST API

The **Histogram** method computes the entities matching a [structured query expressions](concepts-query-expressions.md) and then calculates the distribution of the requested attributes values in the matched entities.

This method is useful for determining the most dominant attribute values in a result set, e.g. finding the most dominant conference Microsoft publishes in (see [examples](#examples) section below).

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/calchistogram?expr={expr}
```  

With optional parameters:

``` HTTP
GET http://{serviceName}.{serviceRegion}.cloudapp.azure.com/calchistogram?expr={expr}&attributes={attributes}&offset={offset}&count={count}
```  

## URI Parameters

Name | Required | Type | Description
--- | --- | --- | ---
`expr` | Required | string | Structured query expression for generating entities used in calculating histograms. See [structured query expressions](concepts-query-expressions.md) for documentation.
`attributes` | Optional | string | A list of comma-separated attributes to generate histograms for. See the [entity schema](reference-makes-api-entity-schema.md) for the attributes that can be requested. If no attributes are specified the response will still include the total number of matching entities. <br/><br/>Defaults to an empty string.
`offset` | Optional | integer | The number of histogram values to skip. <br/><br/>Defaults to 0.
`count` | Optional | integer | The number of histogram values to return for each attribute. <br/><br/>Defaults to 10.

## Responses

Name | Type | Description
--- | --- | ---
200 OK | [HistogramResponse](#histogramresponse) | Histogram response was successfully generated and returned.

## Definitions

| | |
| --- | --- |
[HistogramAttribute](#histogramattribute) | Information for an individual attribute
[HistogramAttributeValue](#histogramattributevalue) | Information for a distinct attribute value
[HistogramResponse](#histogramresponse) | Histogram response information

### HistogramAttribute

Name | Type | Description
--- | --- | ---
attribute | string | The name of the attribute which the histogram was computed from
total_count | long | Total sum of HistogramAttributeValue.count for each attribute
histogram | [HistogramAttributeValue](#histogramattributevalue)[] | Histogram value distribution for this attribute

### HistogramAttributeValue

Name | Type | Description
--- | --- | ---
count | integer | Number of entities that contain this attribute value
logprob | double | Total log probability of entities with this attribute value
value | string | Attribute value

### HistogramResponse

Name | Type | Description
--- | --- | ---
expr | string | The query expression used when generating this response
histograms | [HistogramAttribute](#histogramattribute)[] | An array of containing each requested attribute histogram
num_entities | integer | The number of matching entities that were used to generate histograms

## Examples

### Retrieve top fields of study and conferences that Microsoft published papers in during 2019

#### Request headers

```http
GET /calchistogram?expr=And(Composite(AA.AfN=%27microsoft%27),Y=2019)&attributes=C.CN,F.DFN&offset=0&count=10 HTTP/1.1
Host: makesexample.westus.cloudapp.azure.com
Connection: keep-alive
Upgrade-Insecure-Requests: 1
User-Agent: contoso/1.0
Accept: application/json
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
```

#### Response header

```http
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Content-Type: application/json; charset=utf-8
Server: Kestrel
X-Powered-By: ASP.NET
Date: Thu, 30 Jan 2020 01:13:55 GMT
```

#### Response payload

```json
{
    "expr": "And(Composite(AA.AfN='microsoft'),Y=2019)",
    "num_entities": 4105,
    "histograms": [
        {
            "attribute": "F.DFN",
            "total_count": 29487,
            "histogram": [
                {
                    "value": "Computer science",
                    "logprob": -13.2814656282,
                    "count": 723
                },
                {
                    "value": "Artificial intelligence",
                    "logprob": -13.6597285405,
                    "count": 463
                },
                {
                    "value": "Machine learning",
                    "logprob": -14.3021129241,
                    "count": 234
                },
                {
                    "value": "Mathematics",
                    "logprob": -15.0039503834,
                    "count": 125
                },
                {
                    "value": "Pattern recognition",
                    "logprob": -15.0478221223,
                    "count": 124
                },
                {
                    "value": "Mathematical optimization",
                    "logprob": -15.2300784152,
                    "count": 91
                },
                {
                    "value": "Natural language processing",
                    "logprob": -15.2373057752,
                    "count": 101
                },
                {
                    "value": "Computer vision",
                    "logprob": -15.5599853001,
                    "count": 72
                },
                {
                    "value": "Artificial neural network",
                    "logprob": -15.6770119544,
                    "count": 61
                },
                {
                    "value": "Human–computer interaction",
                    "logprob": -15.6965576647,
                    "count": 70
                }
            ]
        },
        {
            "attribute": "C.CN",
            "total_count": 1177,
            "histogram": [
                {
                    "value": "NeurIPS",
                    "logprob": -15.6239271308,
                    "count": 80
                },
                {
                    "value": "ICLR",
                    "logprob": -16.0151330218,
                    "count": 32
                },
                {
                    "value": "AAAI",
                    "logprob": -16.0266640511,
                    "count": 64
                },
                {
                    "value": "CVPR",
                    "logprob": -16.1798076114,
                    "count": 47
                },
                {
                    "value": "CHI",
                    "logprob": -16.2706730235,
                    "count": 50
                },
                {
                    "value": "ICML",
                    "logprob": -16.2763427142,
                    "count": 38
                },
                {
                    "value": "ACL",
                    "logprob": -16.4683918984,
                    "count": 46
                },
                {
                    "value": "IJCNLP",
                    "logprob": -16.7728936933,
                    "count": 43
                },
                {
                    "value": "NAACL",
                    "logprob": -16.8508525822,
                    "count": 31
                },
                {
                    "value": "ICCV",
                    "logprob": -16.9291530404,
                    "count": 31
                }
            ]
        }
    ],
    "timed_out": false
}
```