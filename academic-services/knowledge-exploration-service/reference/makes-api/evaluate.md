---
title: Microsoft Academic Services
description: Microsoft Academic Services provide Azure based solutions for interacting with the Microsoft Academic Graph, a comprehensive, heterogeneous graph of the worlds scientific publications
---
# Evaluate method

The *evaluate* method evaluates and returns the output of a structured query expression based on the index data.

Typically, an expression will be obtained from a response to the interpret method.  But you can also compose query expressions yourself (see [Structured Query Expression](https://docs.microsoft.com/en-us/azure/cognitive-services/KES/expressions)).  

## Request

`http://<host>/evaluate?expr=<expr>&attributes=<attrs>[&<options>]`

Name | Value | Description
--- | --- | ---
expr | Text string | Structured query expression that selects a subset of index entities.
attributes | Text string | Comma-delimited list of attributes to include in response.
count | Number (default=10) | Maximum number of results to return.
offset | Number (default=0) | Index of the first result to return.
orderby |  string | Name of attribute used to sort the results, followed by optional sort order (default=asc): "*attrname*[:(asc&#124;desc)]".  If not specified, the results are returned by decreasing natural log probability.
timeout | Number (default=1000) | Timeout in milliseconds. Only results computed before the timeout has elapsed are returned.

Using the *count* and *offset* parameters, a large number of results may be obtained incrementally over multiple requests.
  
## Responses

### 200 OK

JSONPath | Description
--- | ---
$.expr | *expr* parameter from the request.
$.entities | Array of 0 or more object entities matching the structured query expression.
$.aborted | True if the request timed out.

Each entity contains a *logprob* value and the values of the requested attributes.

#### Example

In the academic publications example, the following request passes a structured query expression (potentially from the output of an *interpret* request) and retrieves a few attributes for the top 2 matching entities:

`http://<host>/evaluate?expr=Composite(AA.AuN=='jaime teevan')&attributes=Ti,Y,AA.AuN,AA.AuId&count=2`

The response contains the top 2 ("count=2") most likely matching entities.  For each entity, the title, year, author name, and author ID attributes are returned.  Note how the structure of composite attribute values matches the way they are specified in the data file.

```json
{
    "expr": "Composite(AA.AuN=='jaime teevan')",
    "entities": [
        {
            "logprob": -17.155,
            "Id": 2157025439,
            "Ti": "what do people ask their social networks and why a survey study of status message q a behavior",
            "Y": 2010,
            "AA": [
                {
                    "AuN": "meredith ringel morris",
                    "AuId": 2123314761
                },
                {
                    "AuN": "jaime teevan",
                    "AuId": 1982462162
                },
                {
                    "AuN": "katrina panovich",
                    "AuId": 2031349766
                }
            ]
        },
        {
            "logprob": -17.173,
            "Id": 2122841972,
            "Ti": "personalizing search via automated analysis of interests and activities",
            "Y": 2005,
            "AA": [
                {
                    "AuN": "jaime teevan",
                    "AuId": 1982462162
                },
                {
                    "AuN": "susan t dumais",
                    "AuId": 676500258
                },
                {
                    "AuN": "eric horvitz",
                    "AuId": 1970391018
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