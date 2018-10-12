---
title: Microsoft Academic Services
description: Microsoft Academic Services provide Azure based solutions for interacting with the Microsoft Academic Graph, a comprehensive, heterogeneous graph of the worlds scientific publications
---
# Interpret method

The *interpret* method takes a natural language query string and returns formatted interpretations of user intent based on the [grammar](../engines/semantic-interpretation-engine-grammar.md) and index data.  To provide an interactive search experience, this method may be called as each character is entered by the user with the *complete* parameter set to 1 to enable auto-complete suggestions.

## Request

`http://<host>/interpret?query=<query>[&<options>]`

Name | Value | Description
--- | --- | ---
query | Text string | Query entered by user.  If complete is set to 1, query will be interpreted as a prefix for generating query auto-completion suggestions.
complete | 0 (default) or 1 | 1 means that auto-completion suggestions are generated based on the grammar and index data.
count | Number (default=10) | Maximum number of interpretations to return.
offset | Number (default=0) | Index of the first interpretation to return.  For example, *count=2&offset=0* returns interpretations 0 and 1. *count=2&offset=2* returns interpretations 2 and 3.
timeout | Number (default=1000) | Timeout in milliseconds. Only interpretations found before the timeout has elapsed are returned.

Using the *count* and *offset* parameters, a large number of results may be obtained incrementally over multiple requests.

## Responses

### 200 OK

JSONPath | Description
--- | ---
$.query | *query* parameter from the request.
$.interpretations | Array of 0 or more ways to match the input query against the grammar.
$.interpretations[\*].logprob | Relative log probability of the interpretation (<= 0).  Higher values are more likely.
$.interpretations[\*].parse | XML string that shows how each part of the query was interpreted.
$.interpretations[\*].rules | Array of 1 or more rules defined in the grammar invoked during interpretation.
$.interpretations[\*].rules[\*].name | Name of the rule.
$.interpretations[\*].rules[\*].output | Semantic output of the rule.
$.interpretations[\*].rules[\*].output.type | Data type of the semantic output.
$.interpretations[\*].rules[\*].output.value | Value of the semantic output.  
$.aborted | True if the request timed out.

#### Parse XML

The parse XML annotates the (completed) query with information about how it matches against the rules in the grammar and attributes in the index.  Below is an example from the academic publications domain for the query "harry shum 2000"

```xml
<rule name="#GetPapers">
    <attr name="academic#AA.AuN" canonical="heungyeung shum">harry shum</attr>
    <attr name="academic#Y">2000</attr>
</rule>
```

The `<rule>` element delimits the range in the query matching the rule specified by its `name` attribute.  It may be nested when the parse involves rule references in the grammar.

The `<attr>` element delimits the range in the query matching the index attribute specified by its `name` attribute.  When the match involves a synonym in the input query, the `canonical` attribute will contain the canonical value matching the synonym from the index.

#### Example

In the academic publications example, the following request returns up to 2 auto-completion suggestions for the prefix query "papers by jaime":

`http://<host>/interpret?query=papers by jaime&complete=1&count=2`

The response contains the top two ("count=2") most likely interpretations that complete the partial query "papers by jaime t": "papers by jaime toribio perez" and "papers by jaime teevan".  The service generated query completions instead of considering only exact matches for the author "jaime" because the request specified "complete=1". Note that the canonical value "j parez" matched via the synonym "jamie toribio perez", as indicated in the parse.


```json
{
    "query": "papers by jaime t",
    "interpretations": [
        {
            "logprob": -27.463,
            "parse": "<rule name=\"#GetPapers\">papers by <attr name=\"academic#AA.AuN\" canonical=\"j perez\">jaime toribio perez</attr></rule>",
            "rules": [
                {
                    "name": "#GetPapers",
                    "output": {
                        "type": "query",
                        "value": "Composite(AA.AuN=='j perez')"
                    }
                }
            ]
        },
        {
            "logprob": -28.158,
            "parse": "<rule name=\"#GetPapers\">papers by <attr name=\"academic#AA.AuN\">jaime teevan</attr></rule>",
            "rules": [
                {
                    "name": "#GetPapers",
                    "output": {
                        "type": "query",
                        "value": "Composite(AA.AuN=='jaime teevan')"
                    }
                }
            ]
        }
    ]
}
```  

When the type of semantic output is "query", as in this example, the matching objects can be retrieved by passing *output.value* to the [*evaluate*](evaluateMethod.md) API via the *expr* parameter, e.g.:

`http://<host>/evaluate?expr=Composite(AA.AuN=='jaime teevan')`

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
        "Message":"complete should be 1 or 0"
    }
}
```

### 500 Internal server error

JSONPath | Description
--- | ---
$.error.code | Classifies the server error
$.error.message | Provides more verbose details about the error if possible