---
title: Semantic interpretation API reference
description: The Microsoft Academic Knowledge Exploration Service semantic interpretation API enables natural language query interpretation and completions for entities in the Microsoft Academic Graph
ms.topic: reference
ms.date: 03/18/2018
---
# Microsoft Academic Knowledge Exploration Service semantic interpretation API

> [!IMPORTANT]
> We will be publishing a new version of MAKES in early 2020.  This version will be a turn-key solution to host MAKES in your Azure subscription.  For users of Project Academic Knowledge, this MAKES version will mirror the schema and API methods supported by Project Academic Knowledge, enabling users to host their own un-throttled version of the API.

The Microsoft Academic Knowledge Exploration Service semantic interpretation API enables natural language query interpretation and completions for entities in the Microsoft Academic Graph. It generates query expressions which can be evaluated using the [entity APIs](reference-entity-engine.md) evaluate API method.

## Open Data License: [ODC-BY](https://opendatacommons.org/licenses/by/1.0/)

When using Microsoft Academic data (MAG, MAKES, etc.) in a product or service, or including data in a redistribution, please acknowledge Microsoft Academic using the URI https://aka.ms/msracad. For publications and reports, please cite the following article:

> [!NOTE]
> Arnab Sinha, Zhihong Shen, Yang Song, Hao Ma, Darrin Eide, Bo-June (Paul) Hsu, and Kuansan Wang. 2015. An Overview of Microsoft Academic Service (MA) and Applications. In Proceedings of the 24th International Conference on World Wide Web (WWW '15 Companion). ACM, New York, NY, USA, 243-246. DOI=http://dx.doi.org/10.1145/2740908.2742839

## Paper entity schema

> [!IMPORTANT]
> Each API (semantic interpretation, entity) indexes a different set of attributes for paper entities

Attribute | Description | Type | Operations
--- | --- | --- | ---
D | Publication date | Date | Equals, IsBetween
Pt | Publication type | String | Equals
Ti | Normalized paper title | String | Equals, StartsWith
W | Collection of words found in normalized paper title | String[] | Equals
Y | Publication year | Int32 | Equals, IsBetween
AA | Author affiliation composite collection | Composite[] | N/A
AA.AuN | Normalized author name | String | Equals, StartsWith
AA.AfN | Normalized author affiliation name | String | Equals, StartsWith
C | Conference series composite | Composite | N/A
C.CN | Normalized conference series name | String | Equals, StartsWith
CI | Conference instance composite | Composite | N/A
CI.CIN | Normalized conference instance name | String | Equals
F | Field of study composite collection | Composite[] | N/A
F.FN | Normalized field of study name | String | Equals, StartsWith
J | Journal composite | Composite | N/A
J.JN | Normalized journal name | String | Equals, StartsWith

## Speech Recognition Grammar Specification (SRGS) grammar

Speech Recognition Grammar Specification (SRGS) is a [W3C recommended standard](https://www.w3.org/TR/speech-grammar/) for defining the syntax for grammar representation.

``` XML
<grammar root="GetPapers">
  <import schema="schema.json" name="academic"/>

  <rule id="GetPapers">
    <tag>
      query = All(); 
    </tag>
    <one-of>

      <!-- Structured interpretations for query suggestions-->
      <item logprob="-1.000">
        <one-of>
          <item logprob="-0.003">papers</item>
          <item logprob="-0.010">paper</item>
          <item logprob="-0.050"></item>
        </one-of>
        
        <item repeat="0-INF">

          <!-- Don't suggest more after end-of-string -->
          <tag>
            temp = GetVariable("IsBeyondEndOfQuery", "system");
            AssertEquals(temp, false);
          </tag>

          <one-of>
            <!-- by field of study -->
            <item logprob="-5.000">
              <attrref uri="academic#F.FN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by field of study with qualifiers -->
            <item logprob="-10.000">
              <one-of>
                <item>about</item>
              </one-of>
              <attrref uri="academic#F.FN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q); 
              </tag>
            </item>

            <!-- by author -->
            <item logprob="-5.000">
              <attrref uri="academic#AA.AuN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by author with qualifiers -->
            <item logprob="-10.000">
              <one-of>
                <item>by</item>
                <item>authored by</item>
                <item>written by</item>
              </one-of>
              <attrref uri="academic#AA.AuN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by affiliation -->
            <item logprob="-5.000">
              <attrref uri="academic#AA.AfN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by affiliation with qualifiers -->
            <item logprob="-10.000">
              <one-of>
                <item>from</item>
                <item>from institution</item>
              </one-of>
              <attrref uri="academic#AA.AfN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by author and affiliation -->
            <item logprob="-7.000">
              <attrref uri="academic#AA.AuN" name="q1"/>
              <attrref uri="academic#AA.AfN" name="q2"/>
              <tag>
                cq = And(q1, q2); 
                q = Composite(cq); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by affiliation and affiliation -->
            <item logprob="-7.000">
              <attrref uri="academic#AA.AfN" name="q1"/>
              <attrref uri="academic#AA.AuN" name="q2"/>
              <tag>
                cq = And(q1, q2); 
                q = Composite(cq); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by author and affiliation with qualifiers -->
            <item logprob="-12.000">
              <one-of>
                <item>by</item>
                <item>authored by</item>
                <item>written by</item>
              </one-of>
              <attrref uri="academic#AA.AuN" name="q1"/>
              <attrref uri="academic#AA.AfN" name="q2"/>
              <tag>
                cq = And(q1, q2); 
                q = Composite(cq); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by journal -->
            <item logprob="-5.000">
              <attrref uri="academic#J.JN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by journal with qualifiers -->
            <item logprob="-10.000">
              <one-of>
                <item>in</item>
                <item>in journal</item>
              </one-of>
              <attrref uri="academic#J.JN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by conference -->
            <item logprob="-5.000">
              <attrref uri="academic#C.CN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- by conference with qualifiers -->
            <item logprob="-10.000">
              <one-of>
                <item>in</item>
                <item>in conference</item>
              </one-of>
              <attrref uri="academic#C.CN" name="q"/>
              <tag>
                q = Composite(q); 
                query = And(query, q);
              </tag>
            </item>

            <!-- written during a specfic year/paper -->
            <item logprob="-10.000">
              <attrref uri="academic#Y" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- written during a specfic year/paper with qualifiers -->
            <item logprob="-15.000">
              <one-of>
                <item>written during</item>
                <item>written in</item>
                <item>from</item>
              </one-of>
              <attrref uri="academic#Y" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- written before a specfic year/paper -->
            <item logprob="-15.000">
              <one-of>
                <item>before</item>
                <item>written before</item>
              </one-of>
              <attrref uri="academic#Y" op="lt" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- written after a specific year/paper -->
            <item logprob="-15.000">
              <one-of>
                <item>after</item>
                <item>written after</item>
              </one-of>
              <attrref uri="academic#Y" op="gt" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- written since a specific year/paper -->
            <item logprob="-15.000">
              <one-of>
                <item>since</item>
                <item>written since</item>
              </one-of>
              <attrref uri="academic#Y" op="ge" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- by title -->
            <item logprob="-15.000">
              <attrref uri="academic#Ti" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- by title with qualifiers -->
            <item logprob="-20.000">
              <one-of>
                <item>named</item>
                <item>titled</item>
                <item>with name</item>
                <item>with title</item>
              </one-of>
              <attrref uri="academic#Ti" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- by title word -->
            <item logprob="-40.000">
              <attrref uri="academic#W" name="q"/>
              <tag>
                query = And(query, q);
              </tag>
            </item>

            <!-- stop words -->
            <item logprob="-50.000">
              <one-of>
                <item>and</item>
                <item>for</item>
                <item>are</item>
                <item>from</item>
                <item>have</item>
                <item>results</item>
                <item>based</item>
                <item>between</item>
                <item>can</item>
                <item>has</item>
                <item>analysis</item>
                <item>been</item>
                <item>not</item>
                <item>method</item>
                <item>also</item>
                <item>new</item>
                <item>its</item>
                <item>all</item>
                <item>but</item>
                <item>during</item>
                <item>after</item>
                <item>into</item>
                <item>other</item>
                <item>our</item>
                <item>non</item>
                <item>present</item>
                <item>most</item>
                <item>only</item>
                <item>however</item>
                <item>associated</item>
                <item>compared</item>
                <item>des</item>
                <item>related</item>
                <item>proposed</item>
                <item>about</item>
                <item>each</item>
                <item>obtained</item>
                <item>increased</item>
                <item>had</item>
                <item>among</item>
                <item>due</item>
                <item>how</item>
                <item>out</item>
                <item>les</item>
                <item>los</item>
                <item>abstract</item>
                <item>del</item>
                <item>many</item>
                <item>der</item>
                <item>including</item>
                <item>could</item>
                <item>report</item>
                <item>cases</item>
                <item>possible</item>
                <item>further</item>
                <item>given</item>
                <item>result</item>
                <item>las</item>
                <item>being</item>
                <item>like</item>
                <item>any</item>
                <item>made</item>
                <item>because</item>
                <item>discussed</item>
                <item>known</item>
                <item>recent</item>
                <item>findings</item>
                <item>reported</item>
                <item>considered</item>
                <item>described</item>
                <item>although</item>
                <item>available</item>
                <item>particular</item>
                <item>provides</item>
                <item>improved</item>
                <item>here</item>
                <item>need</item>
                <item>improve</item>
                <item>analyzed</item>
                <item>either</item>
                <item>produced</item>
                <item>demonstrated</item>
                <item>evaluated</item>
                <item>provided</item>
                <item>did</item>
                <item>does</item>
                <item>required</item>
                <item>before</item>
                <item>along</item>
                <item>presents</item>
                <item>having</item>
                <item>much</item>
                <item>near</item>
                <item>demonstrate</item>
                <item>iii</item>
                <item>often</item>
                <item>making</item>
                <item>the</item>
                <item>that</item>
                <item>with</item>
                <item>this</item>
                <item>were</item>
                <item>was</item>
                <item>which</item>
                <item>study</item>
                <item>using</item>
                <item>these</item>
                <item>their</item>
                <item>used</item>
                <item>than</item>
                <item>use</item>
                <item>such</item>
                <item>when</item>
                <item>well</item>
                <item>some</item>
                <item>through</item>
                <item>there</item>
                <item>under</item>
                <item>they</item>
                <item>within</item>
                <item>will</item>
                <item>while</item>
                <item>those</item>
                <item>various</item>
                <item>where</item>
                <item>then</item>
                <item>very</item>
                <item>who</item>
                <item>und</item>
                <item>should</item>
                <item>thus</item>
                <item>suggest</item>
                <item>them</item>
                <item>therefore</item>
                <item>since</item>
                <item>une</item>
                <item>what</item>
                <item>whether</item>
                <item>una</item>
                <item>von</item>
                <item>would</item>
                <item>of</item>
                <item>in</item>
                <item>a</item>
                <item>to</item>
                <item>is</item>
                <item>on</item>
                <item>by</item>
                <item>as</item>
                <item>de</item>
                <item>an</item>
                <item>be</item>
                <item>we</item>
                <item>or</item>
                <item>s</item>
                <item>it</item>
                <item>la</item>
                <item>e</item>
                <item>en</item>
                <item>i</item>
                <item>no</item>
                <item>et</item>
                <item>el</item>
                <item>do</item>
                <item>up</item>
                <item>se</item>
                <item>un</item>
                <item>ii</item>
              </one-of>
            </item>

          </one-of>

        </item>

        <!-- Finalize, mark that we've found at least one non-fulltext interpretation -->
        <tag>
          query = Resolve(query);
          cnt = Count(query);
          AssertNotEquals(cnt, 0);
          out = query;
          SetVariable("StructuredQuery", 1, "request");        
        </tag>
      </item>

    </one-of>

  </rule>
</grammar>
```