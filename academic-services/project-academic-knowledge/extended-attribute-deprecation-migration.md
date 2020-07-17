# Deprecation of Entity Extended Attributes

The Extended Entity Attributes is being deprecated and Evaluate/Histogram API will start return attribute not found error when requested on December 21, 2020. The Extended Entity Attributes provides extended entity information such as paper BibTex venue name, citation contexts, original paper title, and DOI are being deprecated. Equivalent information can be found from other available attributes. The other equivalent attributes can also perform more operations. Please transition your API usage to leverage the equivalent available attributes.

## Migration Considerations

If your application depends on Extended Entity Attributes, you'll have the migrate your application before December 21, 2020. You can migrate your application by changing the Evaluate/Histogram API requests construction and response handling.

### Evaluate/Histogram API requests

You'll have to request each extended attributes explicitly. You can find the equivalent attributes in the [Entity Attribute Reference](./reference-entity-attributes.md)

For example, considering the following Evaluate request to get all papers ID, title, and extended attributes from 2020:

```JSON
 {
    "attributes" : "Id, Ti, E",
    "expr" : "And(Y=2020, Ty='0')"
 }
```

Should be changed to the following:

```JSON
 {
    "attributes" : "Id, Ti, BT, BV, CC, DN, DOI, FP, I, IA, LP, PB, S, V, VFN, VSN",
    "expr" : "And(Y=2020, Ty='0')"
 }
```

### Evaluate/Histogram API responses

After migrating your Evaluate and Histogram requests, you'll need to ensure your application can handle the new response correctly.
