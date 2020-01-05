# Interpret

The interpret REST API takes an end user query string (i.e., a query entered by a user of your application) and returns formatted interpretations of user intent based on the MAKES index data and the MAKES Grammar.

To provide an interactive experience, you can call this method repeatedly after each character entered by the user. In that case, you should set the complete parameter to 1 to enable auto-complete suggestions. If your application does not need auto-completion, you should set the complete parameter to 0.

```http
http:{MAKES_API_NAME}.{MAKES_API_REGION}.cloudapp.azure.com/interpret
```

## Parameters

### POST Request

### GET Request

## Request Response

## Examples
