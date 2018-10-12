---
title: Microsoft Academic Services
description: Microsoft Academic Services provide Azure based solutions for interacting with the Microsoft Academic Graph, a comprehensive, heterogeneous graph of the worlds scientific publications
---
# Calculate histogram method

The *histogram* method computes the objects matching a structured query expression and calculates the distribution of their attribute values.

## Request

`http://<host>/histogram?expr=<expr>[&options]`

Name | Value | Description
--- | --- | ---
expr | Text string | Structured query expression that specifies the index entities over which to calculate histograms.
attributes | Text string (default="") | Comma-delimited list of attribute to included in the response.
count | Number (default=10) | Number of results to return.
offset | Number (default=0) | Index of the first result to return.

## Responses

### 200 OK

JSONPath | Description
----|----
$.expr | *expr* parameter from the request.
$.num_entities | Total number of matching entities.
$.histograms |	Array of histograms, one for each requested attribute.
$.histograms[\*].attribute | Name of the attribute over which the histogram was computed.
$.histograms[\*].distinct_values | Number of distinct values among matching entities for this attribute.
$.histograms[\*].total_count | Total number of value instances among matching entities for this attribute.
$.histograms[\*].histogram | Histogram data for this attribute.
$.histograms[\*].histogram[\*].value | Attribute value.
$.histograms[\*].histogram[\*].logprob	| Total natural log probability of matching entities with this attribute value.
$.histograms[\*].histogram[\*].count	| Number of matching entities with this attribute value.
$.aborted | True if the request timed out.

### Example: Paper count by year for author

The following calculates a histogram of paper counts by year for a particular author since 2013:

`http://<host>/histogram?expr=And(Composite(AA.AuN=='jaime teevan'),Y>=2013)&attributes=Y`

The response indicates that there are 76 papers matching the query expression.  For the *Y* (year) attribute, there are 6 distinct values, one for each year since 2013.  The total paper count over the 6 distinct values is 76.  For each distinct *Y*, the histogram shows the value, total natural log probability, and count of matching entities.

```json
{
    "expr": "And(Composite(AA.AuN=='jaime teevan'),Y>=2013)",
    "num_entities": 76,
    "histograms": [
        {
            "attribute": "Y",
            "distinct_values": 6,
            "total_count": 76,
            "histogram": [
                {
                    "value": 2013,
                    "logprob": -17.089,
                    "count": 18
                },
                {
                    "value": 2014,
                    "logprob": -17.181,
                    "count": 13
                },
                {
                    "value": 2016,
                    "logprob": -17.687,
                    "count": 17
                },
                {
                    "value": 2015,
                    "logprob": -17.705,
                    "count": 13
                },
                {
                    "value": 2017,
                    "logprob": -18.332,
                    "count": 12
                },
                {
                    "value": 2018,
                    "logprob": -19.451,
                    "count": 3
                }
            ]
        }
    ]
}
```

### 400 Bad request

JSONPath | Description
--- | ---
$.error.code | Classifies what part of the request was bad
$.error.message | Describes in detail why the request was bad and how it can be fixed

#### Example

```json
{
    "Error":
    {
        "Code":"Bad Argument",
        "Message":"Invalid query expression\r\nParameter name: expression"
    }
}
```
### 500 Internal server error

JSONPath | Description
--- | ---
$.error.code | Classifies the server error
$.error.message | Provides more verbose details about the error if possible