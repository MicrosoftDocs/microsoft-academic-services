---
title: Structured query expressions
description: Learn how to use structured query expressions
ms.topic: reference
ms.date: 2020-02-10
---

# Structured query expressions

A structured query expression specifies a set of operations to evaluate against the index for the purpose of retrieving entities.  It consists of both attribute query expressions and higher-level functions.  

Structured query expressions can either be [*automatically* generated for natural language queries](concepts-queries.md) using the [Interpret method](reference-get-interpret.md) or manually created. They are used by the [Evaluate method](reference-get-evaluate.md) to retrieve matching entities and by the [CalcHistogram method](reference-get-histogram.md) to calculate the distribution of attribute values for matching entities.

To learn more about their structure and syntax please see below.

## Attribute query expression

Attribute query expressions are lookup operations for indexed attributes. Different operations are supported depending on the attribute type and how it was indexed in the [entity schema](reference-makes-api-entity-schema.md):

Type | Operation | Example
--- | --- | ---
String | equals | Ti='latent semantic analysis'  (canonical + synonyms)
String | equals | Composite(AA.AuN=='susan t dumais')  (canonical only)
String | starts_with | Composite(AA.AuN='susan t'...)
Int32/Int64/Double | equals | Y=2000
Int32/Int64/Double | starts_with | Y='20'... (any decimal value starting with "20")
Int32/Int64/Double | is_between | Y&lt;2000 <br/> Y&lt;=2000 <br/> Y&gt;2000 <br/> Y&gt;=2000 <br/> Y=[2010,2012) *(includes only left boundary value: 2010, 2011)* <br/> Y=[2000,2012] *(includes both boundary values: 2010, 2011, 2012)*
Date | equals | D='1984-05-14'
Date | is_between | D&lt;='2008/03/14' <br/> D=['2000-01-01','2009-12-31']

For example, the expression "Composite(AA.AuN='susan t'...)" matches all academic papers with an author who's name starts with the string "susan t".  

For attributes with associated synonyms, a query expression may specify objects whose canonical value matches a given string using the "==" operator, or objects where any of its canonical/synonym values match using the "=" operator.  Both require the "equals" operator to be specified in the attribute definition.

## Functions

There are a built-in set of functions allowing the construction of more sophisticated query expressions using the basic attribute queries.

### And function

```
And(expr1, expr2)
```

Returns the intersection of the two input query expressions.

The following example returns academic publications published in the year 2000 about information retrieval:

```
And(Y=2000, Composite(F.FN=='information retrieval'))
```

### Or function

```
Or(expr1, expr2)
```

Returns the union of the two input query expressions.

The following example returns academic publications published in the year 2000 about information retrieval or user modeling:

```
And(Y=2000, Or(Composite(F.FN='information retrieval'), Composite(F.FN='user modeling')))
```

### Composite function

```
Composite(expr)
```

The Composite function evaluates the enclosed expression against individual composite attribute values of an entity, meaning that for an entity to match an expression it must contain a *single composite attribute value* that matches the entire enclosed expression.

For example, given the following entity:

```JSON
{
  "Ti": "linguistic regularities in continuous space word representations",
  "AA": [
    {
      "AuN": "tomas mikolov",
      "AfN": "google"
    },
    {
      "AuN": "wen tau yih",
      "AfN": "microsoft"
    },
    {
      "AuN": "geoffrey zweig",
      "AfN": "microsoft"
    }
  ]
}
```

Remembering that the Composite function evaluates the enclosed expression against *individual composite attributes*, the following expression would *not* match the above paper as it requires an individual AA attribute value that matches *both* "geoffrey zweig" and "google":

```
Composite(And(AA.AuN='geoffrey zweig',AA.AfN='google'))
```

Changing the expression so that the And function is enclosing *two separate Composite functions* would successfully retrieve the paper:

```
And(Composite(AA.AuN='geoffrey zweig'),Composite(AA.AfN'='google'))
```

>![IMPORTANT]
>MAKES requires that all attribute expressions referencing a composite attribute **must be enclosed by a Composite function**, therefore it is important to understand how the function behaves.

## See also

[Interpret API method documentation](reference-get-interpret.md)

[Evaluate API method documentation](reference-get-evaluate.md)

[Natural language queries](concept-queries.md)
