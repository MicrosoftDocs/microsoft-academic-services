---
title: Entity data files
description: Describes the format for defining entity data to be indexed
ms.topic: tutorial
ms.date: 8/5/2020
---

# Entity data files

Entity data files define the entity data to be indexed. Each row contains information for a single entity, defined in [JSON format](https://json.org/) and conforming to a specific [schema](how-to-index-schema.md) with optional information about its relative probability among other entities.

## Entity data JSON format

Entity data is represented with JSON objects, with attributes values being represented by JSON name/value pairs conforming to the following rules:

Attribute type | JSON value type | Example
--- | --- | ---
blob | string | `"Abstract": "It was the best of times, it was the worst of times ... It is a far, far better thing that I do, than I have ever done; it is a far, far better rest that I go to than I have ever known."`
composite | object | `"F": { "FN": "machine learning", "FId": 119857082 }`
date | string | `"D": "2015-05-18"`
double | number | `"logprob": -2.71828182846`
int32 | number | `"Y": 2015`
int64 | number | `"Id": 8589934592`
guid | string | `"Guid": "3d119f86-dcf0-4e35-9c01-b84832d851e9"`
string | string | `"Ti": "an overview of microsoft academic service mas and applications"`

### Multiple attribute values

To define more than one value for an attribute use JSON arrays, e.g.:

``` JSON
{ "RId": [ 123, 456 ] }
{ "F": [ { "FN": "machine learning", "FId": 119857082 }, { "FN": "artificial intelligence", "FId": 154945302 } ] }
```

## Entity log probability

An important component of the KES top-N retrieval algorithm is the concept of entity probability, which informs KES of each entities relative importance. Entity probability can be understood as the likelihood of it being named the most important in a survey conducted on all members its network/graph ([see "Saliency: An Eigencentrality Measure for Heterogeneous Dynamic Network" in "A Review of Microsoft Academic Services for Science of Science Studies"](https://www.frontiersin.org/articles/10.3389/fdata.2019.00045/pdf)).

KES allows this to be defined for an entity as a relative log probability using the optional "logprob" attribute, which is an additional attribute that is always available and not defined in the [schema](how-to-index-schema.md). Given a probability *p* between 0 and 1, the corresponding log probability can be computed as log(*p*), where log() is the natural log function. When no value is specified for logprob, the default value 0 is used.

## Entity data file format

An entity data file contains one or more rows/lines of [entity data](#entity-data-json-format), and is used as the "data file" when [building an index](how-to-index-build.md).

> [!IMPORTANT]
> While each **row** in an entity data file must be a valid JSON object, the overall file itself is not JSON but simply a *rows/lines of JSON objects*. The file contents are **NOT** meant to be an array of JSON objects.

> [!TIP]
> If your entities use a log probability score, you can significantly increase the performance of indexing by pre-sorting the entity data by the log probability score in descending order (entity with highest log probability in first row, entity with lowest log probability in last row).

## Example

### Academic paper entity

The following entity JSON data is for an index that supports academic paper entities and uses a subset ([defined in the schema how-to](how-to-index-schema.md#example)) of the full [MAKES academic entity schema](reference-makes-api-entity-schema.md).

> [!IMPORTANT]
> The following example is purposefully using tabular formatting of the JSON data to make it easy to understand. However in practice **this data would have no such formatting and be contained on a *single* line**.

``` JSON
{
  "logprob": -19.425,
  "Id": 2964178568,
  "Ti": "improving subseasonal forecasting in the western u s with machine learning",
  "W": [ "improving", "subseasonal", "forecasting", "in", "the", "western", "u", "s", "with", "machine", "learning" ],
  "AW": [ "water", "managers", "western", "united", "states", "u", "rely", "longterm", "forecasts", "temperature", "precipitation", "prepare", "droughts", "wet", "weather", "extremes", "accuracy", "bureau", "reclamation", "national", "oceanic", "atmospheric", "administration", "noaa", "launched", "subseasonal", "climate", "forecast", "rodeo", "year", "long", "real", "time", "forecasting", "challenge", "participants", "aimed", "skillfully", "predict", "two", "four", "weeks", "six", "advance", "evaluate", "machine", "learning", "approach", "release", "subseasonalrodeo", "dataset", "collected", "train", "system", "ensemble", "nonlinear", "regression", "models", "first", "integrates", "diverse", "collection", "meteorological", "measurements", "dynamic", "model", "prunes", "irrelevant", "predictors", "customized", "multitask", "feature", "selection", "procedure", "second", "uses", "historical", "target", "variable", "introduces", "nearest", "neighbor", "features", "weighted", "local", "linear", "alone", "significantly", "more", "accurate", "debiased", "operational", "cfsv2", "skill", "exceeds", "top", "competitor", "horizon", "moreover", "over", "2011", "2018", "improves", "40", "50", "129", "169", "hope", "both", "methods", "help", "state", "art" ],
  "Y": 2019,
  "D": "2019-07-25",
  "CC": 3,
  "RId": [ 2173251738, 2011301426, 1485009520, 2127170577, 2342249984, 2060172488, 2131070146, 2176050019, 2084279619, 2083124794, 2141394518, 2140603473, 2333252900, 2002521620, 2043436896, 2963345431, 2610217940, 2903758338, 2071932996, 1975028308, 2160203977, 2768728801, 2417064059, 2044123688, 2738930091, 2515684462, 2771590586, 2343760727, 2027079844, 2102947218, 2524056393, 2800258827, 2255269585, 2790650423, 2793367185, 3000744823, 1502391765, 3014027346 ],
  "DN": "Improving Subseasonal Forecasting in the Western U.S. with Machine Learning",
  "DOI": "10.1145/3292500.3330674",
  "LP": "2335",
  "FP": "2325",
  "BK": "KDD",
  "PB": "ACM",
  "VSN": "KDD",
  "IA": {
    "IndexLength": 251,
    "InvertedIndex": {
      "Water": [ 0 ],
      "managers": [ 1 ],
      "in": [ 2, 57, 67, 80, 132, 248 ],
      "the": [ 3, 27, 33, 39, 47, 68, 92, 122, 133, 154, 180, 195, 243, 246 ],
      "western": [ 4, 69 ],
      "United": [ 5 ],
      "States": [ 6 ],
      "(U.S.)": [ 7 ],
      "rely": [ 8 ],
      "on": [ 9 ],
      "longterm": [ 10, 31 ],
      "forecasts": [ 11, 131 ],
      "of": [ 12, 29, 36, 114, 125, 153, 194, 211, 245 ],
      "temperature": [ 13, 64, 225 ],
      "and": [ 14, 20, 38, 42, 65, 75, 85, 94, 102, 128, 136, 160, 188, 203, 215, 226, 236 ],
      "precipitation": [ 15, 66 ],
      "to": [ 16, 61, 72, 77, 91, 100, 241 ],
      "prepare": [ 17 ],
      "for": [ 18, 199, 224, 228 ],
      "droughts": [ 19 ],
      "other": [ 21 ],
      "wet": [ 22 ],
      "weather": [ 23 ],
      "extremes.": [ 24 ],
      "To": [ 25 ],
      "improve": [ 26 ],
      "accuracy": [ 28 ],
      "these": [ 30 ],
      "forecasts,": [ 32 ],
      "U.S.": [ 34, 70, 183 ],
      "Bureau": [ 35 ],
      "Reclamation": [ 37 ],
      "National": [ 40 ],
      "Oceanic": [ 41 ],
      "Atmospheric": [ 43 ],
      "Administration": [ 44 ],
      "(NOAA)": [ 45 ],
      "launched": [ 46 ],
      "Subseasonal": [ 48 ],
      "Climate": [ 49, 184 ],
      "Forecast": [ 50 ],
      "Rodeo,": [ 51 ],
      "a": [ 52, 141, 167 ],
      "year-long": [ 53 ],
      "real-time": [ 54 ],
      "forecasting": [ 55, 105 ],
      "challenge": [ 56 ],
      "which": [ 58 ],
      "participants": [ 59 ],
      "aimed": [ 60 ],
      "skillfully": [ 62 ],
      "predict": [ 63 ],
      "two": [ 71, 115 ],
      "four": [ 73, 76 ],
      "weeks": [ 74, 79 ],
      "six": [ 78 ],
      "advance.": [ 81 ],
      "Here": [ 82 ],
      "we": [ 83 ],
      "present": [ 84 ],
      "evaluate": [ 86, 103 ],
      "our": [ 87, 96, 104, 189, 212, 234, 237 ],
      "machine": [ 88 ],
      "learning": [ 89 ],
      "approach": [ 90 ],
      "Rodeo": [ 93, 197 ],
      "release": [ 95 ],
      "SubseasonalRodeo": [ 97, 134 ],
      "dataset,": [ 98 ],
      "collected": [ 99 ],
      "train": [ 101 ],
      "system.": [ 106 ],
      "Our": [ 109 ],
      "system": [ 110 ],
      "is": [ 111, 175 ],
      "an": [ 112, 209 ],
      "ensemble": [ 113, 190, 210 ],
      "nonlinear": [ 116 ],
      "regression": [ 117, 213 ],
      "models.": [ 118 ],
      "The": [ 119, 147 ],
      "first": [ 120 ],
      "integrates": [ 121 ],
      "diverse": [ 123 ],
      "collection": [ 124 ],
      "meteorological": [ 126 ],
      "measurements": [ 127, 152 ],
      "dynamic": [ 129 ],
      "model": [ 130, 173 ],
      "dataset": [ 135, 235 ],
      "prunes": [ 137 ],
      "irrelevant": [ 138 ],
      "predictors": [ 139 ],
      "using": [ 140 ],
      "customized": [ 142 ],
      "multitask": [ 143, 162 ],
      "feature": [ 144 ],
      "selection": [ 145 ],
      "procedure.": [ 146 ],
      "second": [ 148 ],
      "uses": [ 149 ],
      "only": [ 150 ],
      "historical": [ 151 ],
      "target": [ 155, 201 ],
      "variable": [ 156, 202 ],
      "(temperature": [ 157 ],
      "or": [ 158 ],
      "precipitation)": [ 159 ],
      "introduces": [ 161 ],
      "nearest": [ 163 ],
      "neighbor": [ 164 ],
      "features": [ 165 ],
      "into": [ 166 ],
      "weighted": [ 168 ],
      "local": [ 169 ],
      "linear": [ 170 ],
      "regression.": [ 171 ],
      "Each": [ 172 ],
      "alone": [ 174 ],
      "significantly": [ 176 ],
      "more": [ 177 ],
      "accurate": [ 178 ],
      "than": [ 179 ],
      "debiased": [ 181, 216, 219 ],
      "operational": [ 182 ],
      "Forecasting": [ 185 ],
      "System": [ 186 ],
      "(CFSv2),": [ 187 ],
      "skill": [ 191, 221 ],
      "exceeds": [ 192 ],
      "that": [ 193, 232 ],
      "top": [ 196 ],
      "competitor": [ 198 ],
      "each": [ 200 ],
      "forecast": [ 204 ],
      "horizon.": [ 205 ],
      "Moreover,": [ 206 ],
      "over": [ 207 ],
      "2011-2018,": [ 208 ],
      "models": [ 214 ],
      "CFSv2": [ 217, 220 ],
      "improves": [ 218 ],
      "by": [ 222 ],
      "40-50%": [ 223 ],
      "129-169%": [ 227 ],
      "precipitation.": [ 229 ],
      "We": [ 230 ],
      "hope": [ 231 ],
      "both": [ 233 ],
      "methods": [ 238 ],
      "will": [ 239 ],
      "help": [ 240 ],
      "advance": [ 242 ],
      "state": [ 244 ],
      "art": [ 247 ],
      "subseasonal": [ 249 ],
      "forecasting.": [ 250 ]
    }
  },
  "S": [
    {
      "Ty": 3,
      "U": "https://arxiv.org/pdf/1809.07394.pdf"
    },
    {
      "Ty": 3,
      "U": "https://www.microsoft.com/en-us/research/uploads/prod/2018/12/1809.07394.pdf"
    },
    {
      "Ty": 1,
      "U": "https://arxiv.org/abs/1809.07394"
    },
    {
      "Ty": 1,
      "U": "https://dblp.uni-trier.de/db/conf/kdd/kdd2019.html#HwangOCPM19"
    },
    {
      "Ty": 1,
      "U": "https://dl.acm.org/citation.cfm?id=3330674"
    },
    {
      "Ty": 1,
      "U": "https://www.kdd.org/kdd2019/accepted-papers#238"
    },
    {
      "Ty": 1,
      "U": "https://www.microsoft.com/en-us/research/publication/improving-subseasonal-forecasting-in-the-western-u-s-with-machine-learning-2/"
    }
  ],
  "AA": [
    {
      "DAuN": "Jessica Hwang",
      "AuN": "jessica hwang",
      "AuId": 2900591679,
      "DAfN": "Stanford University",
      "AfN": "stanford university",
      "AfId": 97018004,
      "S": 1
    },
    {
      "DAuN": "Paulo Orenstein",
      "AuN": "paulo orenstein",
      "AuId": 2634142713,
      "DAfN": "Stanford University",
      "AfN": "stanford university",
      "AfId": 97018004,
      "S": 2
    },
    {
      "DAuN": "Judah Cohen",
      "AuN": "judah cohen",
      "AuId": 2138981458,
      "DAfN": "Atmospheric and Environmental Research, Lexington, MA, USA",
      "S": 3
    },
    {
      "DAuN": "Karl Pfeiffer",
      "AuN": "karl pfeiffer",
      "AuId": 2691472296,
      "DAfN": "Atmospheric and Environmental Research, Lexington, MA, USA",
      "S": 4
    },
    {
      "DAuN": "Lester Mackey",
      "AuN": "lester mackey",
      "AuId": 2134505947,
      "DAfN": "Microsoft",
      "AfN": "microsoft",
      "AfId": 1290206253,
      "S": 5
    }
  ],
  "F": [
    {
      "DFN": "k-nearest neighbors algorithm",
      "FN": "k nearest neighbors algorithm",
      "FId": 113238511
    },
    {
      "DFN": "Wet weather",
      "FN": "wet weather",
      "FId": 2991722355
    },
    {
      "DFN": "Regression analysis",
      "FN": "regression analysis",
      "FId": 152877465
    },
    {
      "DFN": "Precipitation",
      "FN": "precipitation",
      "FId": 107054158
    },
    {
      "DFN": "Nonlinear regression",
      "FN": "nonlinear regression",
      "FId": 46889948
    },
    {
      "DFN": "Machine learning",
      "FN": "machine learning",
      "FId": 119857082
    },
    {
      "DFN": "Local regression",
      "FN": "local regression",
      "FId": 60316415
    },
    {
      "DFN": "Feature selection",
      "FN": "feature selection",
      "FId": 148483581
    },
    {
      "DFN": "Computer science",
      "FN": "computer science",
      "FId": 41008148
    },
    {
      "DFN": "Climate forecast",
      "FN": "climate forecast",
      "FId": 2994424460
    },
    {
      "DFN": "Artificial intelligence",
      "FN": "artificial intelligence",
      "FId": 154945302
    }
  ],
  "C": {
    "CN": "kdd",
    "CId": 1130985203
  },
  "CI": {
    "CIN": "kdd 2019",
    "CIId": 2992576872
  }
}
```
