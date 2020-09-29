---
title: Grammar build procedure
description: Defines how to build and test a grammar from schema, grammar XML index files using the KESM command line tool
ms.topic: how-to
ms.date: 9/1/2020
---

# How to build and test a custom grammar

Describes how to use KESM to build a MAKES index on a win-x64 machine using the example data provided in the "Create custom MAKES index" how-to guides.

## Prerequisites

- Microsoft Academic Knowledge Exploration Service (MAKES) subscription. See [Get started with Microsoft Academic Knowledge Exploration Service](get-started-setup-provisioning.md) to obtain one
- Complete the ["create custom MAKES index"](how-to-index-build.md) how-to guide

## Create local files

Navigate to the win-x64/kesm sub-folder of the directory where you unzipped the KESM package and generated the example schema and index detailed in the ["create custom MAKES index"](how-to-index-build.md) how-to guide, then generate the following file:

### grammar.xml

```xml
<grammar root="paperQuery">
  <import schema="schema.json" name="paperEntity" />

  <rule id="paperQuery">

    <!-- Variable containing final structured query expression -->
    <tag>outputQueryExpression = All();</tag>

    <!-- The following enclosure is repeated indefinitely (one to infinity), 
       with each repeat incurring a weight penalty of -1 -->
    <item repeat="1-" repeat-logprob="-1">

      <one-of>

        <!-- Match paper conference series attribute -->
        <item>
          <attrref uri="paperEntity#C.CN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper conference instance attribute -->
        <item>
          <attrref uri="paperEntity#CI.CIN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper field of study attribute -->
        <item>
          <attrref uri="paperEntity#F.FN" name="matchedAttribute" />
          <tag>matchedAttribute = Composite(matchedAttribute);</tag>
        </item>

        <!-- Match paper title word attribute -->
        <item>
          <attrref uri="paperEntity#W" name="matchedAttribute" />
        </item>

        <!-- Match paper publication year attribute -->
        <item>
          <ruleref uri="#paperYear" name="matchedAttribute" />
        </item>

      </one-of>

      <!-- Add matched attribute to existing query expression as a new constraint -->
      <tag>outputQueryExpression = And(outputQueryExpression, matchedAttribute);</tag>
    </item>

    <!-- Set output of rule to the query expression we constructed above -->
    <tag>out = Resolve(outputQueryExpression);</tag>

  </rule>

  <rule id="paperYear">

    <one-of>

      <!-- Match paper publication year attribute -->
      <item>
        <attrref uri="paperEntity#Y" name="out" />
      </item>

      <!-- Match paper publication year attribute before a specific year -->
      <item>
        <one-of>
            <item>before</item>
            <item logprob="-1">written before</item>
        </one-of>
        <attrref uri="paperEntity#Y" name="out" op="lt" />
      </item>

      <!-- Match paper publication year attribute after a specific year -->
      <item>
        <one-of>
            <item>after</item>
            <item logprob="-1">written after</item>
        </one-of>
        <attrref uri="paperEntity#Y" name="out" op="gt" />
      </item>

    </one-of>

  </rule>

</grammar>
```

## Build grammar

Open a Windows command prompt (cmd.exe), navigate to the directory where you installed (unzipped) the KESM command line tool and execute the following command:

```cmd
Kesm.exe CompileGrammarLocal --GrammarDefinitionFilePath grammar.xml --OutputCompiledGrammarFilePath grammar
```

## Test grammar

Verify that your grammar works by executing the following command and comparing its output with the sample output below.

### Test interpret command

Command:

```cmd
Kesm.exe Interpret --IndexFilePaths index --GrammarFilePath grammar --AllowCompletion "false" --InterpretationEntityAttributes "DN" --InterpretationEntityCount 1 --Query "knowledge discovery and data mining 2019 deep learning"
```

Output:

```json
{
  "query": "knowledge discovery and data mining 2019 deep learning",
  "interpretations": [
    {
      "logprob": -19.942,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#CI.CIN\" canonical=\"kdd 2019\">knowledge discovery and data mining 2019</attr> <attr name=\"paperEntity#F.FN\">deep learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(Composite(CI.CIN=='kdd 2019'),Composite(F.FN='deep learning'))",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -20.942,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#C.CN\" canonical=\"kdd\">knowledge discovery and data mining</attr><rule name=\"#paperYear\"> <attr name=\"paperEntity#Y\">2019</attr></rule> <attr name=\"paperEntity#F.FN\">deep learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(Composite(C.CN=='kdd'),Y=2019),Composite(F.FN='deep learning'))",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        },
        {
          "name": "#paperYear",
          "output": {
            "type": "query",
            "value": "Y=2019",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -21.03,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#CI.CIN\" canonical=\"kdd 2019\">knowledge discovery and data mining 2019</attr> <attr name=\"paperEntity#W\">deep</attr> <attr name=\"paperEntity#W\">learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(Composite(CI.CIN=='kdd 2019'),W='deep'),W='learning')",
            "entities": [
              {
                "logprob": -19.03,
                "prob": 5.4372088E-09,
                "DN": "Sherlock: A Deep Learning Approach to Semantic Data Type Detection"
              }
            ]
          }
        }
      ]
    },
    {
      "logprob": -22.03,
      "parse": "<rule name=\"#paperQuery\"><attr name=\"paperEntity#C.CN\" canonical=\"kdd\">knowledge discovery and data mining</attr><rule name=\"#paperYear\"> <attr name=\"paperEntity#Y\">2019</attr></rule> <attr name=\"paperEntity#W\">deep</attr> <attr name=\"paperEntity#W\">learning</attr><end/></rule>",
      "rules": [
        {
          "name": "#paperQuery",
          "output": {
            "type": "query",
            "value": "And(And(And(Composite(C.CN=='kdd'),Y=2019),W='deep'),W='learning')",
            "entities": [
              {
                "logprob": -19.03,
                "prob": 5.4372088E-09,
                "DN": "Sherlock: A Deep Learning Approach to Semantic Data Type Detection"
              }
            ]
          }
        },
        {
          "name": "#paperYear",
          "output": {
            "type": "query",
            "value": "Y=2019",
            "entities": [
              {
                "logprob": -18.942,
                "prob": 5.9373674E-09,
                "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks"
              }
            ]
          }
        }
      ]
    }
  ],
  "timed_out_count": 0,
  "timed_out": false
}
```
