---
title: Grammar syntax
description: Reference documentation for the syntactic elements supported by the MAKES grammar
ms.topic: reference
ms.date: 12/09/2020
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Grammar syntax

## Components of a grammar

### grammar element

The `grammar` element is the top-level element in the grammar specification XML.  The required `root` attribute specifies the name of the root rule that defines the starting point of the grammar.

```xml
<grammar root="paperQuery">
```

### import element

The `import` element imports a schema definition from an external file to enable attribute references. The element must be a child of the top-level `grammar` element and appear before any `attrref` elements. The required `schema` attribute specifies the name of a schema file located in the same directory as the grammar XML file. The required `name` element specifies the schema alias that subsequent `attrref` elements use when referencing attributes defined within this schema.

```xml
  <import schema="schema.json" name="paperEntity" />
```

### rule element

The `rule` element defines a grammar rule, a structural unit that specifies a set of query expressions that the system can interpret.  The element must be a child of the top-level `grammar` element.  The required `id` attribute specifies the name of the rule, which is referenced from `grammar` or `ruleref` elements.

A `rule` element defines a set of legal expansions.  Text tokens match against the input query directly.  `item` elements specify repeats and alter interpretation probabilities. `one-of` elements indicate alternative choices. `ruleref` elements enable construction of more complex expansions from simpler ones.  `attrref` elements allow matches against attribute values from the index. `tag` elements specify the semantics of the interpretation and can alter the interpretation probability.

```xml
<rule id="paperQuery">...</rule>
```

### item element

The `item` element groups a sequence of grammar constructs.  It can be used to indicate repetitions of the expansion sequence, or to specify alternatives in conjunction with the `one-of` element.

When an `item` element is not a child of a `one-of` element, it can specify repetition of the enclosed sequence by assigning the `repeat` attribute to a count value.  A count value of "*n*" (where *n* is an integer) indicates that the sequence must occur exactly *n* times.  A count value of "*m*-*n*" allows the sequence to appear between *m* and *n* times, inclusively.  A count value of "*m*-" specifies that the sequence must appear at least *m* times.  The optional `repeat-logprob` attribute can be used to alter the interpretation probability for each additional repetition beyond the minimum.

```xml
<item repeat="1-" repeat-logprob="-1">...</item>
```

When `item` elements appear as children of a `one-of` element (see below), they define the set of expansion alternatives.  In this usage, the optional `logprob` attribute specifies the relative log probability among the different choices.  Given a probability *p* between 0 and 1, the corresponding log probability can be computed as log(*p*), where log() is the natural log function.  If not specified, `logprob` defaults to 0, which does not alter the interpretation probability.  Note that log probability is always a negative floating-point value or 0.

### one-of element

The `one-of` element specifies alternative expansions among one of the child `item` elements.  Only `item` elements may appear inside a `one-of` element.  Relative probabilities among the different choices may be specified via the `logprob` attribute in each child `item`.

```xml
  <one-of>
    <item>before</item>
    <item logprob="-1">written before</item>
  </one-of>
```

### regex element

The `regex` element specifies valid expansions via matching text tokens against a regular expression through the required `pattern` attribute . Normally, the pattern will only be used to match against a single text token at a time. If a match is found, the text token will be stored as the output in the variable specified by the `name` attribute. If the pattern is `.*`, all remaining text tokens will be matched and stored as output.

```xml
<regex pattern="\d+" name="matchedDigits" />
```

### ruleref element

The `ruleref` element specifies valid expansions via references to another `rule` element.  Through the use of `ruleref` elements, more complex expressions can be built from simpler rules.  The required `uri` attribute indicates the name of the referenced `rule` using the syntax "#*rulename*".  To capture the semantic output of the referenced rule, use the optional `name` attribute to specify the name of a variable to which the semantic output is assigned.

```xml
<ruleref uri="#paperYear" name="matchedAttribute" />
```

### attrref element

The `attrref` element references an index attribute, allowing matching against attribute values observed in the index.  The required `uri` attribute specifies the index schema name and attribute name using the syntax "*schemaName*#*attrName*".  There must be a preceding `import` element that imports the schema named *schemaName*.  The attribute name is the name of an attribute defined in the corresponding schema.

In addition to matching user input, the `attrref` element also returns a structured query object as output that selects the subset of objects in the index matching the input value.  Use the optional `name` attribute to specify the name of the variable where the query object output should be stored.  The query object can be composed with other query objects to form more complex expressions.  See [structured query expressions](concepts-query-expressions.md) for details.  

```xml
<attrref uri="paperEntity#C.CN" name="matchedAttribute" />
```

### tag element

The `tag` element specifies how a path through the grammar is to be interpreted.  It contains a sequence of semicolon-terminated statements.  A statement may be an assignment of a literal or a variable to another variable.  It may also assign the output of a semantic function with 0 or more parameters to a variable.  Each semantic function parameter may be specified using a literal or a variable.  If the semantic function does not return any output, the assignment is omitted.  Variable scope is local to the containing rule.

```xml
<tag>x = 1; y = x;</tag>
<tag>q = All(); q = And(q, q2);</tag>
<tag>AssertEquals(x, 1);</tag>
```

Some statements may alter the probability of an interpretation path by introducing an additive log probability offset.  Some statements may reject the interpretation altogether if specified conditions are not satisfied.

For a full list of supported semantic functions, see [semantic functions](reference-semantic-functions.md).

### out variable

Each `rule` defined in the grammar is required to generate semantic output, represented by a predefined variable named `out`.

Its value is computed by evaluating each of the semantic statements traversed by the path through the `rule` matching the user query input.  The value assigned to the `out` variable at the end of the evaluation is the semantic output of the rule.  The semantic output of interpreting a user query against the grammar is the semantic output of the root rule.

## Query completions

To support query completions when interpreting partial user queries, each referenced attribute must include "starts_with" as an operation in the schema definition.  Given a user query prefix, `attrref` will match all values in the index that complete the prefix, and yield each complete value as a separate interpretation of the grammar.  

## Matching operations

In addition to exact match, select attribute types also support prefix and inequality matches via the optional `op` attribute.  If no object in the index has a value that matches, the grammar path is blocked and the service will not generate any interpretations traversing over this grammar path.   The `op` attribute defaults to "eq".

```xml
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
```

The following table lists the supported `op` values for each attribute type.  Their use requires the corresponding index operation to be included in the schema attribute definition.

| Attribute Type | Op Value | Description | Index Operation
|----|----|----|----|
| String | eq | String exact match | equals |
| String | starts_with | String prefix match | starts_with |
| Int32, Int64, Double | eq |  Numeric equality match | equals |
| Int32, Int64, Double | lt, le, gt, ge | Numeric inequality match (<, <=, >, >=) | is_between |
| Int32, Int64, Double | starts_with | Prefix match of value in decimal notation | starts_with |

## Interpretation probability

The probability of an interpretation path through the grammar is the cumulative log probability of all the `<item>` elements and semantic functions encountered along the way.  It describes the relative likelihood of matching a particular input sequence.

Given a probability *p* between 0 and 1, the corresponding log probability can be computed as log(*p*), where log() is the natural log function.  Using log probabilities allows the system to accumulate the joint probability of an interpretation path through simple addition.  It also avoids floating-point underflow common to such joint probability calculations.  Note that by design, the log probability is always a negative floating-point value or 0, where larger values indicate higher likelihood.

## Example grammar

See below for an example grammar that defines rules for matching a small subset of attributes from the [example academic paper entity schema](how-to-index-schema.md#academic-paper-entity-schema) against a natural language query. This example grammar is part of the [custom MAKES grammar](how-to-grammar.md) how-to guide:

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
