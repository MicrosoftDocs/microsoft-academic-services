---
title: Add search to the library browser
description: Step by step tutorial to design MAKES grammar for custom data
ms.topic: tutorial
ms.date: 11/16/2020
---
# Add search to the library browser

This tutorial is a continuation of the ["Build a library browser with contextual filters"](tutorial-entity-linking.md) tutorial.

This tutorial illustrates how to

- Create a MAKES Index tailored for library publication entities search
- Design a MAKES grammar to process natural language search queries
- Build, compile and deploy a MAKES instance with custom index and grammar
- Extend the library browser with search capability using MAKES APIs

![Library search application](media/privateLibraryExampleApp-homepage-search.png)

## Prerequisites

- [Microsoft Academic Knowledge Exploration Service (MAKES) subscription](get-started-setup-provisioning.md) (release version after 2020-11-30)
- Completion of ["Link private publication records with MAKES entities"](tutorial-entity-linking.md) tutorial
- Completion of ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial
- Read through ["How to define index schema"](how-to-index-schema.md) how-to guide
- Read through ["How to define grammar"](how-to-grammar.md) how-to guide
- Download the [sample search schema for linked private library publications](samplePrivateLibraryData.linked.search.schema.json)
- Download the [sample search grammar for linked private library publications](samplePrivateLibraryData.linked.search.grammar.xml)

## Create a searchable index

In order to search the index, we will have modify the schema from ["Build a library browser with contextual filters"](tutorial-entity-linking.md) tutorial and add index operations on more attributes.

### Modify schema to support search

We modified/added the following attributes from the ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial to make the index searchable.

| Attribute Name | Description| Index Data Type | Index Operations |
| ---- | ---- | ---- | ---- |
| `Abstract.Words` | A words array containing all distinct words from the publication's abstract. Used for supporting partial matches in abstract search (partial attribute search). | `string*` | `["equals"]` |
| `DOI` | Indicates that "DOI" attribute is a object composed of multiple attributes | `Composite?` | - |
| `DOI.Name` | Used for providing direct match in DOI search (attribute search). | `string?` | `["equals"]` |
| `Title` | Indicates that "Title" attribute is an object composed of multiple attributes | `Composite?` | - |
| `Title.Name` | Used for providing direct match in title search (attribute search). | `blob?` | - |
| `Title.Words` | A words array containing all distinct words from the publication's title. Used for supporting partial matches in title search (partial attribute search). | `string*` | `["equals"]` |
| `FullTextUrl` | Indicates that "FullTextUrl" attribute is an object composed of multiple attributes | `Composite?` | - |
| `FullTextUrl.Name` | Used for providing direct match in FullTextUrl lookup (attribute search) | `string?` | `["equals"]` |

#### Search attributes

Attributes that we plan to use for processing search queries needs to be indexed, similar to filter attributes in the ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial. For example, to enable our application to process search queries like "papers from microsoft about machine learning" by enabling the `equals` index operation on the `FieldsOfStudy.Name` and `AuthorAffiliations.AuthorName` attributes.

In addition to indexing the attributes, we also want to normalize the attributes to improve search results. For example, we can improve publication title search accuracy and performance by normalizing the title and search queries to lowercase characters only. For more normalization details, see `MakesInteractor.NormalizeStr(queryStr)` in `makesInteractor.js`

To enable fuzzy search or keyword search, we may also transform the attributes before indexing them. For example, we enable abstract keywords search by transforming the abstract of a publication `Abstract.OriginalName` into `Abstract.Words` such that unique words from the abstract can be indexed.

## Design a search grammar

Then, we will design a grammar tailored to process natural language search queries. In this tutorial, we will use the [sample grammar](samplePrivateLibrary.Data.linked.search.grammar.xml) to illustrate how to support **direct attribute search**, **multiple attribute search**, **partial attribute search**, **semantic search**, and **drop terms with penalties**.

### Support direct attribute search

Direct attribute search is used for processing queries that only contains a single publication attribute. For example, user may want to look up a publication by its title, doi, or full text url. These are basically lookup queries using attributes that can be identifiers of the entities itself. To craft a grammar for direct attribute search, we can use the `<attrref>` element to build our grammar:

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_direct_attribute_search":::

This allows us to process queries such as "paper titled An Overview of Microsoft Academic Service (MAS) and Applications" or "paper with doi 10.1145/2740908.2742839"

We also need to return the corresponding KES query expression once the attribute is matched. The `<attrref uri="libraryPapers#Title.Name" name="q"/>` element will store the matched paper title in a variable called "q". We can then craft our return query by using the following:

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_create_return_query":::

### Support multiple attribute search

Multiple attribute search is used for processing exploratory search queries that contains multiple attribute terms. For example, user may want to search for publications given a few fields of study and affiliations.

We use the repeat item `<item repeat="1-INF" repeat-logprob="-1">` element to process queries that contains multiple attributes by continously matching remaining query terms using different search grammars.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_multiple_attribute_search_loop":::

This allows us to process queries such as "papers from microsoft about machine learning"

### Support partial attribute search

Partial attribute search is used for processing keyword based search queries. For example, user may search for a paper using terms from the paper's title or abstract.

We use a `<item repeat="1-INF">` element to process keyword based queries using abstract and title words.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_partial_attribute_search":::

Notice that we have heavier penalties (-3 and -4) associated with title and abstract word search compared to other. (i.e. author and affiliation searches have a penalty of -2). This is designed to demote title/abstract keyword searches if other searches yield results.

In addition to heavier penalties, we also set a minimum word match count requirement for title and abstract words search. Title and abstract words may cover lots of common terms that can be matched against terms in a query. We introduce this requirement to create a higher quality bar for title and abstract words search results. The following code ensures that the title and abstract words search is only valid if there are 3 or more words in the query that can be matched against the title/abstract words.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_partial_attribute_search_constraints":::

### Support drop terms with penalties

We can improve multiple attribute and partial attribute search by allowing drop/garbage terms in the query. For example, a user may want to search for the publication "A Review of Microsoft Academic Services for Science of Science Studies" by using the parts of the title the user recalls and enters the query "Microsoft Academic Services". Having drop terms support allows this type of queries to be searchable by partial title search.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_allow_drop_terms_in_quries":::

We enable drop terms by using `<regex pattern='\b\w+' name="garbage" />` element to match against any words. We also pick a high penalty `<item logprob="-25">` to discourage query terms being dropped.

We also want to ensure that the grammar cannot drop all terms in a query. To achieve this, we use a variable `hasSearchResult` to represent that at least one type of search was used to process the query and not all terms are being treated as drop/garbage terms.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_drop_term_constraints":::

### Support semantic search

- Multiple attributes from a specific composite

## How to build index, compile grammar, test, and deploy MAKES API

We are now ready to set up a MAKES API instance by building a searchable index, compiling a search grammar, and deploying them.

### How to build index

1. Copy the win-x64 version of kesm.exe to your working directory or include it in your command line PATH variable.

1. Open up a commandline console, change your current directory to your working directory, and build the index with the following command:

    ```cmd
    kesm BuildIndexLocal --SchemaFilePath samplePrivateLibraryData.linked.search.schema.json --EntitiesFilePath samplePrivateLibraryData.linked.json --OutputIndexFilePath samplePrivateLibraryData.linked.search.kes --IndexDescription "Searchable Linked Private Library Publications"
    ```

    > [!IMPORTANT]
    > The `BuildIndexLocal` command is only available on win-x64 version of kesm. If you are using other platforms you will need to execute a cloud build.

### How to test index

1. Run Evaluate command to verify the stored entity attributes are correct:

    ```cmd
    kesm Evaluate --IndexFilePaths samplePrivateLibraryData.linked.search.kes --KesQueryExpression="All()" --Count 1 --Attributes *
    ```

    The output should mirror the following JSON:

    ```json
    {
    "expr": "All()",
    "entities": [
      {
        "logprob": -17.514,
        "prob": 2.4760901E-08,
        "EstimatedCitationCount": "393",
        "VenueFullName": "The Web Conference",
        "Year": 2015,
        "Abstract": {
          "OriginalName": "In this paper we describe a new release of a Web scale entity graph that serves as the backbone of Microsoft Academic Service (MAS), a major production effort with a broadened scope to the namesake vertical search engine that has been publicly available since 2008 as a research prototype. At the core of MAS is a heterogeneous entity graph comprised of six types of entities that model the scholarly activities: field of study, author, institution, paper, venue, and event. In addition to obtaining these entities from the publisher feeds as in the previous effort, we in this version include data mining results from the Web index and an in-house knowledge base from Bing, a major commercial search engine. As a result of the Bing integration, the new MAS graph sees significant increase in size, with fresh information streaming in automatically following their discoveries by the search engine. In addition, the rich entity relations included in the knowledge base provide additional signals to disambiguate and enrich the entities within and beyond the academic domain. The number of papers indexed by MAS, for instance, has grown from low tens of millions to 83 million while maintaining an above 95% accuracy based on test data sets derived from academic activities at Microsoft Research. Based on the data set, we demonstrate two scenarios in this work: a knowledge driven, highly interactive dialog that seamlessly combines reactive search and proactive suggestion experience, and a proactive heterogeneous entity recommendation.",
          "Words": ["in","this","paper","we","describe","a","new","release","of","web","scale","entity","graph","that","serves","as","the","backbone","microsoft","academic","service","mas","major","production","effort","with","broadened","scope","to","namesake","vertical","search","engine","has","been","publicly","available","since","2008","research","prototype","at","core","is","heterogeneous","comprised","six","types","entities","model","scholarly","activities","field","study","author","institution","venue","and","event","addition","obtaining","these","from","publisher","feeds","previous","version","include","data","mining","results","index","an","house","knowledge","base","bing","commercial","result","integration","sees","significant","increase","size","fresh","information","streaming","automatically","following","their","discoveries","by","rich","relations","included","provide","additional","signals","disambiguate","enrich","within","beyond","domain","number","papers","indexed","for","instance","grown","low","tens","millions","83","million","while","maintaining","above","95","accuracy","based","on","test","sets","derived","set","demonstrate","two","scenarios","work","driven","highly","interactive","dialog","seamlessly","combines","reactive","proactive","suggestion","experience","recommendation"]
        },
        "DOI": {
          "OriginalName": "10.1145/2740908.2742839",
          "Name": "10 1145 2740908 2742839"
        },
        "FullTextUrl": {
          "OriginalName": "http://localhost/example-full-text-link-2",
          "Name": "http localhost example full text link 2"
        },
        "Title": {
          "OriginalName": "An Overview of Microsoft Academic Service (MAS) and Applications",
          "Name": "an overview of microsoft academic service mas and applications",
          "Words": ["an","overview","of","microsoft","academic","service","mas","and","applications"]
        },
        "AuthorAffiliations": [
          {
            "AffiliationName": "microsoft",
            "AuthorName": "arnab sinha",
            "OriginalAuthorName": "Arnab Sinha",
            "Sequence": "1"
          },
          {
            "AffiliationName": "microsoft",
            "AuthorName": "zhihong shen",
            "OriginalAuthorName": "Zhihong Shen",
            "Sequence": "2"
          },
          ...
        ],
        "FieldsOfStudy": [
          {
            "OriginalName": "World Wide Web",
            "Name": "world wide web"
          },
          {
            "OriginalName": "Vertical search",
            "Name": "vertical search"
          },
          ...
        ]
      }
    ],
    "timed_out": false
    }
    ```

1. Run Evaluate command using the built index to verify index operations are working as expected:

    ```cmd
    kesm Evaluate --IndexFilePaths samplePrivateLibraryData.linked.search.kes --KesQueryExpression="Year=2020" --Attributes "Year"
    ```

    The output should be

    ```cmd
    {
      "expr": "Year=2020",
      "entities": [
        {
          "logprob": -18.255,
          "prob": 1.18019626E-08,
          "Year": 2020
        },
        {
          "logprob": -19.386,
          "prob": 3.8086159E-09,
          "Year": 2020
        },
        {
          "logprob": -19.625,
          "prob": 2.9989608E-09,
          "Year": 2020
        },
        {
          "logprob": -19.853,
          "prob": 2.3875455E-09,
          "Year": 2020
        },
        {
          "logprob": -20.154,
          "prob": 1.7669693E-09,
          "Year": 2020
        }
      ],
      "timed_out": false
    }
    ```

As discussed in ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial, we use a local build for this tutorial because the amount of data to be indexed is very small. For larger and more complex indexes, cloud build must be used. One advantage of cloud builds is that they can leverage high performance virtual machines in Azure that can dramatically improve build performance. To learn more, follow [How to create index from MAG](how-to-create-index-from-mag.md)

### How to compile grammar

1. Copy the win-x64 version of kesm.exe to your working directory or include it in your command line PATH variable.

1. Open up a commandline console, change your current directory to your working directory, and compile the grammar with the following command:

    ```cmd
    kesm CompileGrammarLocal --GrammarDefinitionFilePath samplePrivateLibraryData.linked.search.grammar.xml --OutputCompiledGrammarFilePath samplePrivateLibraryData.linked.search.grammar.kesg
    ```

    > [!IMPORTANT]
    > The `CompileGrammarLocal` command is only available on win-x64 version of kesm.

### How to test grammar

Open up a commandline console, change your current directory to your working directory, and test the grammar with a multiple attribute search test query ("microsoft machine learning) using the following command:

```cmd
kesm Interpret --IndexFilePaths samplePrivateLibraryData.linked.search.kes --GrammarFilePath samplePrivateLibraryData.linked.search.grammar.kesg --Query "microsoft machine learning" --NormalizeQuery false --AllowCompletion false
```

and you should see the following response

```json
{
"query": "papers from microsoft about machine learning",
"interpretations": [
  {
    "logprob": -20.529,
    "parse": "<rule name=\"#SearchPapers\">papers from <attr name=\"libraryPapers#AuthorAffiliations.AffiliationName\">microsoft</attr> about <attr name=\"libraryPapers#FieldsOfStudy.Name\">machine learning</attr><end/></rule>",
    "rules": [
      {
        "name": "#SearchPapers",
        "output": {
          "type": "query",
          "value": "And(Composite(AuthorAffiliations.AffiliationName='microsoft'),Composite(FieldsOfStudy.Name='machine learning'))",
          "entities": []
        }
      }
    ]
  },
  {
    "logprob": -71.529,
    "parse": "<rule name=\"#SearchPapers\">papers<rule name=\"#DropWord\"> from</rule><rule name=\"#DropWord\"> microsoft</rule> about <attr name=\"libraryPapers#FieldsOfStudy.Name\">machine learning</attr><end/></rule>",
    "rules": [
      {
        "name": "#SearchPapers",
        "output": {
          "type": "query",
          "value": "Composite(FieldsOfStudy.Name='machine learning')",
          "entities": []
        }
      },
      {
        "name": "#DropWord",
        "output": {
          "type": "string",
          "value": "microsoft"
        }
      },
      {
        "name": "#DropWord",
        "output": {
          "type": "string",
          "value": "from"
        }
      }
    ]
  },
  ...
  }
],
"timed_out_count": 0,
"timed_out": false
}
```

The top interpretation's parse shows that the query was interpreted using the **multiple attribute search** grammar path we as we designed. The remaining interpretations represents the drop term grammar that attemps to drop terms from the query but don't yield highier interpretation logprobs.

The top interpretation's `logprob` is the sum of the accumulative grammar weights (grammar path log probability) and the top entity's log probability.

Below is a table of example test queries to validate the search grammar we designed.

| Search Scenario | Test Query | Expected Top Grammar Parse
|---|---|---|
| attribute search |  `paper titled an overview of microsoft academic service mas and applications` | `<rule name=\"#SearchPapers\">paper titled <attr name=\"libraryPapers#Title.Name\">an overview of microsoft academic service mas and applications</attr><end/></rule>`
| multiple attribute search | `papers from microsoft about machine learning` | `<rule name=\"#SearchPapers\">papers from <attr name=\"libraryPapers#AuthorAffiliations.AffiliationName\">microsoft</attr> about <attr name=\"libraryPapers#FieldsOfStudy.Name\">machine learning</attr><end/></rule>`
| partial attribute search | `microsoft academic applications` | `<rule name=\"#SearchPapers\"><attr name=\"libraryPapers#Title.Words\">microsoft</attr> <attr name=\"libraryPapers#Title.Words\">academic</attr> <attr name=\"libraryPapers#Title.Words\">applications</attr><end/></rule>` |
| partial attribute search + drop terms | `microsoft garbageterm garbageterm academic garbageterm applications`| `<rule name=\"#SearchPapers\"><attr name=\"libraryPapers#Title.Words\">microsoft</attr><rule name=\"#DropWord\"> garbageterm</rule><rule name=\"#DropWord\"> garbageterm</rule> <attr name=\"libraryPapers#Title.Words\">academic</attr><rule name=\"#DropWord\"> garbageterm</rule> <attr name=\"libraryPapers#Title.Words\">applications</attr><end/></rule>` |
| multiple attribute search + drop terms | `microsoft garbageterm machine learning garbageterm`| `<rule name=\"#SearchPapers\"><attr name=\"libraryPapers#AuthorAffiliations.AffiliationName\">microsoft</attr><rule name=\"#DropWord\"> garbageterm</rule> <attr name=\"libraryPapers#FieldsOfStudy.Name\">machine learning</attr> garbageterm<end/></rule>` |

## Create a client application that uses the MAKES API instance

Now that we have deployed a MAKES API instance that uses the custom index and grammar, the last step is to create a frontend client to that enables users to browse and filter library publications. In the remaining sections of the tutorial, we will be using the sample UI code to illustrate how to retrieve data and generate filters via MAKES Evaluate and Histogram APIs.

### Explore the library browser application sample

The code for the library browser application sample is part of the standard MAKES deployment. After the MAKES API instance with the custom index build has been fully deployed, you can use the library browser application by visiting the following URL:

`<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`

The remainder of this tutorial details how the library browser application uses the MAKES API to accomplish publication browsing/filtering. To follow along, download the library browser application source files from your MAKES API instance using the following URLs:

- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.css`
- `<Makes_Instance_Url>/examples/privateLibraryExample/results.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/searchResult.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/searchResults.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationFieldsOfStudyListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/makesInteractor.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterSectionListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterAttributeListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterablePublicationList.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filter.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/appliedFilterListItem.js`

Once downloaded, modify the `hostUrl` variable in `makesInteractor.js` and point it to your MAKES instance with custom index. You can then run the application in your browser by opening the `privateLibraryExample.html` file (you can just drag and drop the file into a new browser window).

### Search via Interpret API

We process search queries by calling the Interpret API. MAKES process the query and returns top interpretations along with KES query expressions to retrieve the entities from Evaluate API. For more details, see `async SearchPublications(query)` in `makesInteractor.js`.

We can control the depth of the search by changing the `searchInterpretationsCount` class variable in `MakesInteractor`. Increasing the amount of interpretations we get back from Interpret API means increasing the depth of search.

### Retrieve publications and applying dynamic rank

Similar to how we leverage a KES query expression to retrieve top publications from ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial, we will retrieve top publication entities by calling Evaluate API.

Instead of calling Evaluate API once, we call Evaluate API for each interpretation and merge sort the publications by dynamic rank. We calculate the dynamic rank for a entity by extracting the grammar path log probability as the dynamic rank from the interpretation. To learn more, see `MakesInteractor.GetPublicationsByDynamicRank(searchResults)` in `makesInteractor.js` for more details.

<!--
Next steps: build amazing applications.
-->
