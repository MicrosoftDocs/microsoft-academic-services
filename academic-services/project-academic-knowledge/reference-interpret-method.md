---
title: Interpret method
description: Generates semantic interpretations of a natural language query
ms.topic: reference
ms.date: 03/25/2020
---

# Interpret Method

The **Interpret** method generates semantic interpretations of a natural language query.

It can be used as either a way of interpreting a specific natural language query, or to generate natural language query suggestions using the original query as a stem.

For more information about how Interpret works, see the [natural language queries](concepts-queries.md) documentation.

**REST endpoint:**

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/interpret?
```

## Request Parameters

Name     | Value | Required?  | Description
---------|---------|---------|---------
**query**    | String | Yes | Query entered by user.  If complete is set to 1, query will be interpreted as a prefix for generating query auto-completion suggestions.
**model**    | String | No  | Name of the model that you wish to query.  Currently, the value defaults to *latest*.
**complete** | 0 or 1 | No<br>default:0  | 1 means that auto-completion suggestions are generated based on the grammar and graph data.
**count**    | Number | No<br>default:10 | Maximum number of interpretations to return.
**offset**   | Number | No<br>default:0  | Index of the first interpretation to return. For example, *count=2&offset=0* returns interpretations 0 and 1. *count=2&offset=2* returns interpretations 2 and 3.
**timeout**  | Number | No<br>default:1000 | Timeout in milliseconds. Only interpretations found before the timeout has elapsed are returned. Maximum supported value is 5000 milliseconds (5 seconds).
**entityCount** | Number | No<br>default:0 | The maximum number of entities that should be returned for each interpretation that match the interpreted query expression. <br/><br/>By default this is set to 0, meaning no entities are returned.
**attributes** | String | No | A list of comma-separated attributes to include for each entity returned for each interpretation. See the [paper entity schema](reference-paper-entity-attributes.md) for the attributes that can be requested. <br/><br/>Defaults to an empty string.

## Response (JSON)

Name | Description
--- | ---
**query** | The *query* parameter from the request.
**interpretations** | An array of 0 or more different ways of matching user input against the grammar.
**interpretations[x].logprob** | The relative natural log probability of the interpretation. Larger values are more likely.
**interpretations[x].parse** | An XML string that shows how each part of the query was interpreted.
**interpretations[x].rules** | An array of 1 or more rules defined in the grammar that were invoked during interpretation. For the Academic Knowledge API, there will always be 1 rule.
**interpretations[x].rules[y].name** | Name of the rule.
**interpretations[x].rules[y].output** | Output of the rule.
**interpretations[x].rules[y].output.type** | The data type of the output of the rule.  For the Academic Knowledge API, this will always be "query".
**interpretations[x].rules[y].output.value** | The output of the rule. For the Academic Knowledge API, this is a query expression string that can be passed to the evaluate and calchistogram methods.
**interpretations[x].rules[y].output.entities** | Optional array of top entities matching the interpretation.
**timed_out_count** | Internal service metric.
**timed_out** | True if the full timeout elapsed while generating results.

## Examples

### Generate academic query suggestions
                                                             
This example generates the most likely query suggestions (completions) for a partial author query "author: j tee".

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/interpret?query=author:%20j%20tee&complete=1&count=2
```

The important parts of the request:

* **complete=1**: Indicates that query completions should be generated
* **count=2**: Indicates that only two interpretations should be generated

As you can see from the response below, the most likely interpretations that complete the partial author query *author: j tee* are:

* *author: jaime teevan*
* *author: john r teerlink*

The service generated query completions instead of considering only exact matches for the author *j tee*.
Note that the canonical value *jaime teevan* matched via the synonym *j teevan*, and *john r teerlink* matched via *j teerlink*, as indicated in the "parse" string value.

``` JSON
{
    "query": "author: j tee",
    "interpretations": [{
        "logprob": -16.948,
        "parse": "<rule name=\"#GetPapers\">author: <attr name=\"academic#AA.AuN\" canonical=\"jaime teevan\">j teevan</attr></rule>",
        "rules": [{
            "name": "#GetPapers",
            "output": {
                "type": "query",
                "value": "Composite(AA.AuN=='jaime teevan')"
            }
        }]
    }, {
        "logprob": -16.951,
        "parse": "<rule name=\"#GetPapers\">author: <attr name=\"academic#AA.AuN\" canonical=\"john r teerlink\">j teerlink</attr></rule>",
        "rules": [{
            "name": "#GetPapers",
            "output": {
                "type": "query",
                "value": "Composite(AA.AuN=='john r teerlink')"
            }
        }]
    }],
    "timed_out_count": 0,
    "timed_out": false
}
```

### Map academic reference to paper

This example maps a raw academic reference string to the academic paper that most closely maps to the metadata present in the reference string.

The reference string we will be using:

```
Sinha, Arnab, et al. "An Overview of Microsoft Academic Service (MAS) and Applications." Proceedings of the 24th International Conference on World Wide Web, 2015, pp. 243–246.
```

The HTTP request:

``` HTTP
https://api.labs.cognitive.microsoft.com/academic/v1.0/interpret?query=Sinha,%20Arnab,%20et%20al.%20"An%20Overview%20of%20Microsoft%20Academic%20Service%20(MAS)%20and%20Applications."%20Proceedings%20of%20the%2024th%20International%20Conference%20on%20World%20Wide%20Web,%202015,%20pp.%20243–246.&count=1&entityCount=1&attributes=Id,DN,Y,AA.DAuN,VFN
```

The important parts of the request:

* **count=1**: Indicates that only 1 interpretation should be generated
* **entityCount=1**: Indicates that each interpretation should return the top-most matching entity
* **attributes=Id,DN,Y,AA.DAuN,VFN**: Indicates which [paper entity attributes](reference-paper-entity-attributes.md) should be returned for each matching entity

As you can see from the response below, based on the top entities metadata it is highly likely that the interpretation maps to the correct paper ["An Overview of Microsoft Academic Service (MAS) and Applications"](https://academic.microsoft.com/paper/1932742904).

What's also important to notice about the response is how it only *partially interpretted* the query.
If you look at the "parse" field in the response it shows what parts of the query were mapped to different entity fields.
In this case it was not able to match anything after the title in reference string, but was still able to generate an accurate mapping based on what it *could* match.

``` JSON
{
                                                                "query": "sinha arnab et al an overview of microsoft academic service mas and applications proceedings of the 24th international conference on world wide web 2015 pp 243 246",
    "interpretations": [{
        "logprob": -420.683,
        "parse": "<rule name=\"#GetPapers\"><attr name=\"academic#AA.AuN\" canonical=\"arnab sinha\">sinha arnab</attr> et al <attr name=\"academic#Ti\">an overview of microsoft academic service mas and applications</attr> proceedings of the 24th international conference on world wide web 2015 pp 243 246</rule>",
        "rules": [{
            "name": "#GetPapers",
            "output": {
                "type": "query",
                "value": "And(Composite(AA.AuN=='arnab sinha'),Ti='an overview of microsoft academic service mas and applications')",
                "entities": [{
                    "logprob": -17.683,
                    "prob": 2.09108014e-8,
                    "Id": 1932742904,
                    "Ti": "an overview of microsoft academic service mas and applications",
                    "Y": 2015,
                    "AA": [{
                        "AuN": "arnab sinha"
                    }, {
                        "AuN": "zhihong shen"
                    }, {
                        "AuN": "yang song"
                    }, {
                        "AuN": "hao ma"
                    }, {
                        "AuN": "darrin eide"
                    }, {
                        "AuN": "bojune hsu"
                    }, {
                        "AuN": "kuansan wang"
                    }],
                    "C": {
                        "CN": "www"
                    }
                }]
            }
        }]
    }],
    "timed_out_count": 0,
    "timed_out": false
}
```                                                                                                