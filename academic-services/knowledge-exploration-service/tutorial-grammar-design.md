---
title: Add search to library browser
description: Step by step tutorial to design MAKES grammar for custom data
ms.topic: tutorial
ms.date: 11/16/2020
---
# Add search to library browser

This tutorial is a continuation of the ["Build a library browser with contextual filters"](tutorial-entity-linking.md) tutorial.

This tutorial illustrates how to

- Create a MAKES Index tailored for library publication entities search
- Design a MAKES grammar to process natural language search queries
- Build, compile and deploy a MAKES instance with custom index and grammar
- Extend the library browser with search capability using MAKES APIs

![Library search application](media/privateLibraryExampleApp-homepage.png)

## Prerequisites

- [Microsoft Academic Knowledge Exploration Service (MAKES) subscription](get-started-setup-provisioning.md) (release version after 2020-11-30)
- Completion of ["Link private publication records with MAKES entities"](tutorial-entity-linking.md) tutorial
- Completion of ["Build a library browser with contextual filters"](tutorial-schema-design.md) tutorial
- Read through ["How to define index schema"](how-to-index-schema.md) how-to guide
- Read through ["How to define index schema"](how-to-grammar.md) how-to guide
- Download the [sample search schema for linked private library publications](samplePrivateLibraryData.linked.search.schema.json)
- Download the [sample search grammar for linked private library publications](samplePrivateLibraryData.linked.search.grammar.xml)

## Create a searchable index

In order to search the index, we will have modify the schema from ["Build a library browser with contextual filters"](tutorial-entity-linking.md) tutorial and add index operations on more attributes.

### Modify schema to support search

#### Attribute search
- Title, DOI, or FullTextUrl
- Normalize for search

#### Partial attribute search
- Use words array attributes to allow partial matches
- TitleWords, AbstractWords
- Remove stop words to optimize 

- Search index schema explaination table


## Design a search grammar

Then, we will design a grammar tailored to process natural language search queries. In this tutorial, we will use the [sample grammar](samplePrivateLibrary.Data.linked.search.grammar.xml) to illustrate how to support **direct attribute search**, **multiple attribute search**, **partial attribute search**, **semantic search*, and **drop terms with penalties**.

### Support direct attribute search

Direct attribute search is used for processing simple queries that only contains a single attribute. For example, user may want to look up a publication by its title, doi, or full text url. These are basically lookup queries using attributes that can be identifiers of the entities itself. To craft a grammar for direct attribute match, we can use the `<attrref>` element to build our grammar:

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_direct_attribute_search":::

This allows us to process queries such as "paper titled An Overview of Microsoft Academic Service (MAS) and Applications" or "paper with doi 10.1145/2740908.2742839"

We also need to return the corresponding KES query expression once the attribute is matched. The `<attrref uri="libraryPapers#Title.Name" name="q"/>` element will store the matched paper title in a variable called "q". We can then craft our return query by using the following:

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_create_return_query":::

### Support multiple attribute search

Multiple attribute search is used for processing exploratory search quries that contains multiple attribute terms. For example, user may want to search for publications given a few fields of study and affiliations. 

We use the `<item repeat="1-INF" repeat-logprob="-1">` element to process queries that contains multiple attributes by continously matching remaining query terms using different search grammars. This allows us to process queries such as "papers about machine learning from microsoft"

### Support partial attribute search

Partial attribute search is used for processing keyword based search quries. For example, user may search for a paper using terms from the paper's title or abstract.

To enable partial attribute search for title and abstract, we create words arrays (i.e. Abstract.Words and Title.Words) to store indiviual words from title and abstract so they can be indexed. 

We use a `<item repeat="1-INF">` element to process keyword based queries using abstract and title words.

:::code language="powershell" source="samplePrivateLibraryData.linked.search.grammar.xml" id="snippet_partial_attribute_search":::

Notice that we have a heavier penalty `<item logprob="-3">` associated with title and abstract word search compared to other. (i.e. author and affiliation searches have a penalty of `<item logprob="-2">`). This is designed to demote title/abstract keyword searches if other searches have results. 

In addition to having heavier penalties, we also set a minimum word match count requirement for title and abstract words search. Title and abstract words may cover lots of common terms that can be matched a query. We introduce this requirement to create a highier quality bar for title and abstract words search results. The following code ensures that the title and abstract words search is only valid if there are 3 or more words in the query that can be matched against the title/abstract words.

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

### How to build index
### How to test index
### How to compile grammar
### How to test grammar
#### Use small index to validate logic locally
#### Use large index in pre-prod environment to validate performance

## Create a client application that uses the MAKES API instance

Now that we have deployed a MAKES API instance that uses the custom index build, the last step is to create a frontend client to that enables users to browse and filter library publications. In the remaining sections of the tutorial, we will be using the sample UI code to illustrate how to retrieve data and generate filters via MAKES Evaluate and Histogram APIs.

### Explore the library browser application sample

The code for the library browser application sample is part of the standard MAKES deployment. After the MAKES API instance with the custom index build has been fully deployed, you can use the library browser application by visiting the following URL:

`<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`

The remainder of this tutorial details how the library browser application uses the MAKES API to accomplish publication browsing/filtering. To follow along, download the library browser application source files from your MAKES API instance using the following URLs:

- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.html`
- `<Makes_Instance_Url>/examples/privateLibraryExample/privateLibraryExample.css`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/publicationFieldsOfStudyListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/makesInteractor.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterSectionListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterAttributeListItem.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filterablePublicationList.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/filter.js`
- `<Makes_Instance_Url>/examples/privateLibraryExample/appliedFilterListItem.js`

Once downloaded, modify the `hostUrl` variable in `makesInteractor.js` and point it to your MAKES instance with custom index. You can then run the application in your browser by opening the `privateLibraryExample.html` file (you can just drag and drop the file into a new browser window).

### Search via Interpret
### Retrive publications via Evaluate API
#### Apply dynamic rank to results

