---
title: Semantic functions
description: Reference documentation for the semantic functions supported by the MAKES grammar
ms.topic: reference
ms.date: 12/09/2020
---
[!INCLUDE [ma-retirement](../includes/ma-retirement.md)]

# Semantic functions

Semantic functions associate semantic output with each interpreted path through the grammar.  In particular, the service evaluates the sequence of statements in the `tag` elements traversed by the interpretation to compute the final output.  

A statement may be an assignment of a literal or a variable to another variable.  It may also assign the output of a function with 0 or more parameters to a variable.  Each function parameter may be specified using a literal or a variable.  If the function does not return any output, the assignment is omitted.

```xml
<tag>x = 1; y = x;</tag>
<tag>q = All(); q = And(q, q2);</tag>
<tag>AssertEquals(x, 1);</tag>
```

A variable is specified using a name identifier that starts with a letter and consists only of letters (A-Z), numbers (0-9), and the underscore (\_).  Its type is implicitly inferred from the literal or function output value assigned to it.

Below is a list of currently supported data types:

|Type|Description|Examples|
|----|----|----|
|String|Sequence of 0 or more characters|"Hello World!"<br/>""|
|Bool|Boolean value|true<br/>false|
|Int32|32-bit signed integer.  -2.1e9 to 2.1e9|123<br/>-321|
|Int64|64-bit signed integer. -9.2e18 and 9.2e18|9876543210|
|Double|Double precision floating-point. 1.7e+/-308 (15 digits)|123.456789<br/>1.23456789e2|
|Guid|Globally unique identifier|"602DD052-CC47-4B23-A16A-26B52D30C05B"|
|Query|Query expression that specifies a subset of data objects in the index|All()<br/>And(*q1*, *q2*)|

In addition there are a set of built-in semantic functions.  They allow the construction of sophisticated queries, and provide context sensitive control over grammar interpretations.

## And Function

`query = And(query1, query2);`

Returns a query composed from the intersection of two input queries.

## Or Function

`query = Or(query1, query2);`

Returns a query composed from the union of two input queries.

## All Function

`query = All();`

Returns a query that includes all data objects.

In the following example, we use the All() function to iteratively build up a query based on the intersection of 1 or more keywords.

```xml
<tag>query = All();</tag>
<item repeat="1-">
  <attrref uri="paperEntity#W" name="titleWord">
  <tag>query = And(query, titleWord);</tag>
</item>
```

## None Function

`query = None();`

Returns a query that includes no data objects.

In the following example, we use the None() function to iteratively build up a query based on the union of 1 or more keywords.

```xml
<tag>query = None();</tag>
<item repeat="1-">
  <attrref uri="paperEntity#W" name="titleWord">
  <tag>query = Or(query, titleWord);</tag>
</item>
```

## Query Function

```xml
query = Query(attrName, value)
query = Query(attrName, value, op)
```

Returns a query that includes only data objects whose attribute *attrName* matches value *value* according to the specified operation *op*, which defaults to "eq".  Typically, use an `attrref` element to create a query based on the matched input query string.  If a value is given or obtained through other means, the Query() function can be used to create a query matching this value.

In the following example, we use the Query() function to implement support for specifying academic publications from a particular decade.

```xml
written in the 90s
<tag>
  beginYear = Query("paperEntity#Y", 1990, "ge");
  endYear = Query("paperEntity#Y", 2000, "lt");
  year = And(beginYear, endYear);
</tag>
```

## Composite Function

`query = Composite(innerQuery);`

Returns a query that encapsulates an *innerQuery* composed of matches against sub-attributes of a common composite attribute *attr*.  The encapsulation requires the composite attribute *attr* of any matching data object to have at least one value that individually satisfies the *innerQuery*.  Note that a query on sub-attributes of a composite attribute has to be encapsulated using the Composite() function before it can be combined with other queries.

For example, the following query returns academic publications by "harry shum" while he was at "microsoft":

```xml
Composite(
  And(
    Query("paperEntity#AA.AuN", "harry shum"),
    Query("paperEntity#AA.AfN", "microsoft"))
);
```

On the other hand, the following example returns the academic publications written by "harry shum at microsoft" with other collaborators authors from "carnegie mellon university".

```xml
And(
    Composite(
        And(
            Query("paperEntity#AA.AuN", "harry shum"),
            Query("paperEntity#AA.AfN", "microsoft")
        )
    ),
    Composite(
            Query("paperEntity#AA.AfN", "carnegie mellon university")
        )
    )
)
```

## GetVariable Function

`value = GetVariable(name, scope);`

Returns the value of variable *name* defined under the specified *scope*.  *name* is an identifier that starts with a letter and consists only of letters (A-Z), numbers (0-9), and the underscore (_).  *scope* can be set to "request" or "system".  Note that variables defined under different scopes are distinct from each other, including ones defined via the output of semantic functions.

Request scope variables are shared across all interpretations within the current interpret request.  They can be used to control the search for interpretations over the grammar.

System variables are predefined by the service and can be used to retrieve various statistics about the current state of the system.  Below is the set of currently supported system variables:

|Name|Type|Description|
|----|----|----|
|IsAtEndOfQuery|Bool|true if the current interpretation has matched all input query text|
|IsBeyondEndOfQuery|Bool|true if the current interpretation has suggested completions beyond the input query text|

## SetVariable Function

`SetVariable(name, value, scope);`

Assigns *value* to variable *name* under the specified *scope*.  *name* is an identifier that starts with a letter and consists only of letters (A-Z), numbers (0-9), and the underscore (_).  Currently, the only valid value for *scope* is "request".  There are no settable system variables.

Request scope variables are shared across all interpretations within the current interpret request.  They can be used to control the search for interpretations over the grammar.

## AssertEquals Function

`AssertEquals(value1, value2);`

If *value1* and *value2* are equivalent, the function succeeds and has no side effects.  Otherwise, the function fails and rejects the interpretation.

## AssertNotEquals Function

`AssertNotEquals(value1, value2);`

If *value1* and *value2* are not equivalent, the function succeeds and has no side effects.  Otherwise, the function fails and rejects the interpretation.

## HasResult Function

`value = HasResult(query);`

returns true if the query can retrieve at least one result, otherwise, false.
