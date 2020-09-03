---
title: Index build procedure
description: Defines how to build and test an index from schema, data and synonym files using the KESM command line tool
ms.topic: how-to
ms.date: 9/1/2020
---

# How to build and test a custom index

Describes how to use KESM to build a MAKES index on a win-x64 machine using the example data provided in the "Create custom MAKES index" how-to guides.

## Prerequisites

* Operating system that supports win-x64 executables
* Microsoft Academic Knowledge Exploration Service (MAKES) subscription. See [Get started with Microsoft Academic Knowledge Exploration Service](get-started-setup-provisioning.md) to obtain one.
* Download and install the [KESM command line tool](get-started-create-api-instances#download-the-command-line-tool-kesmexe-from-your-azure-storage-account)

## Create local files

Navigate to the win-x64/kesm sub-folder of the directory where you unzipped the KESM package and create the following files:

### schema.json

```json
{
  "attributes": [
    {
      "name": "AA",
      "type": "Composite*"
    },
    {
      "name": "AA.AfId",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AA.AfN",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ]
    },
    {
      "name": "AA.AuId",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AA.AuN",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ]
    },
    {
      "name": "AA.DAfN",
      "type": "blob?"
    },
    {
      "name": "AA.DAuN",
      "type": "blob?"
    },
    {
      "name": "AA.S",
      "type": "int32?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "AW",
      "type": "string*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "C",
      "type": "Composite?"
    },
    {
      "name": "C.CId",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "C.CN",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "conference-series-synonyms.txt"
    },
    {
      "name": "CC",
      "type": "int32?"
    },
    {
      "name": "CI",
      "type": "Composite?"
    },
    {
      "name": "CI.CIId",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "CI.CIN",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ],
      "synonyms": "conference-instance-synonyms.txt"
    },
    {
      "name": "D",
      "type": "date?",
      "operations": [
        "equals",
        "is_between"
      ]
    },
    {
      "name": "DN",
      "type": "blob?"
    },
    {
      "name": "DOI",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ]
    },
    {
      "name": "F",
      "type": "Composite*"
    },
    {
      "name": "F.DFN",
      "type": "blob?"
    },
    {
      "name": "F.FId",
      "type": "int64",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "F.FN",
      "type": "string?",
      "operations": [
        "equals",
        "starts_with"
      ]
    },
    {
      "name": "FP",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "IA",
      "type": "blob?"
    },
    {
      "name": "Id",
      "type": "int64!",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "LP",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "RId",
      "type": "int64*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "S",
      "type": "blob?"
    },
    {
      "name": "Ti",
      "type": "string?",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "W",
      "type": "string*",
      "operations": [
        "equals"
      ]
    },
    {
      "name": "Y",
      "type": "int32?",
      "operations": [
        "equals",
        "is_between"
      ]
    }
  ]
}
```

### conference-series-synonyms.txt

```json
["kdd", "knowledge discovery and data mining"]
["kdd", "kdd knowledge discovery and data mining"]
["kdd", "acm sigkdd"]
["kdd", "sigkdd"]
```

### conference-instance-synonyms.txt

```json
["kdd 2019", "25th sigkdd conference on knowledge discovery and data mining"]
["kdd 2019", "knowledge discovery and data mining 2019"]
["kdd 2019", "kdd knowledge discovery and data mining 2019"]
["kdd 2019", "acm sigkdd 2019"]
["kdd 2019", "sigkdd 2019"]
```

### data.txt

```json
{ "logprob": -18.942, "Id": 2945827377, "Ti": "cluster gcn an efficient algorithm for training deep and large graph convolutional networks", "W": ["cluster","gcn","an","efficient","algorithm","for","training","deep","and","large","graph","convolutional","networks"], "AW": ["graph","convolutional","network","gcn","successfully","applied","applications","training","large","scale","remains","challenging","current","sgd","algorithms","suffer","high","computational","cost","exponentially","grows","number","layers","space","requirement","keeping","entire","embedding","node","memory","paper","propose","cluster","novel","algorithm","suitable","exploiting","clustering","structure","works","following","step","samples","block","nodes","associate","dense","subgraph","identified","restricts","neighborhood","search","simple","effective","strategy","leads","significantly","efficiency","able","achieve","comparable","test","accuracy","previous","scalability","create","amazon2m","data","2","million","61","edges","more","5","times","larger","largest","publicly","dataset","reddit","3","layer","faster","state","art","vr","1523","seconds","vs","1961","less","2gb","11","furthermore","4","finish","around","36","minutes","existing","fail","train","issue","allows","us","deeper","without","time","overhead","prediction","f1","score","99","ppi","best","98","71","citezhang2018gaan"], "Y": 2019, "D": "2019-07-25", "CC": 49, "RId": [2194775991,2899771611,2964015378,2624431344,2070232376,2027731328,1991418309,2135957668,2807021761,2963695795,2788512147,2963241951,2963581908,2803533564,2963415211,2071128523], "DN": "Cluster-GCN: An Efficient Algorithm for Training Deep and Large Graph Convolutional Networks", "DOI": "10.1145/3292500.3330925", "LP": "266", "FP": "257", "BK": "KDD", "PB": "ACM", "VSN": "KDD", "IA": "{\"IndexLength\": 275,\"InvertedIndex\": {\"2\": [149],\"4\": [203],\"5\": [160],\"36\": [215],\"61\": [153],\"1961\": [190],\"Graph\": [0],\"convolutional\": [1],\"network\": [2],\"(GCN)\": [3],\"has\": [4],\"been\": [5],\"successfully\": [6],\"applied\": [7],\"to\": [8,117,127,225,228,236,249],\"many\": [9],\"graph-based\": [10],\"applications;\": [11],\"however,\": [12],\"training\": [13,70,172,202,222],\"a\": [14,25,38,61,87,94,99,144,173,253],\"large-scale\": [15],\"GCN\": [16,35,63,175,205,221,240],\"remains\": [17],\"challenging.\": [18],\"Current\": [19],\"SGD-based\": [20,69],\"algorithms\": [21,223],\"suffer\": [22],\"from\": [23],\"either\": [24],\"high\": [26],\"computational\": [27,122],\"cost\": [28],\"that\": [29,65,91],\"exponentially\": [30],\"grows\": [31],\"with\": [32,93,132,148],\"number\": [33],\"of\": [34,50,89,139],\"layers,\": [36],\"or\": [37],\"large\": [39],\"space\": [40],\"requirement\": [41],\"for\": [42,68,201],\"keeping\": [43],\"the\": [44,48,73,80,105,137,164,183,219,229,264,268],\"entire\": [45],\"graph\": [46,74,100],\"and\": [47,103,121,152,192,244],\"embedding\": [49],\"each\": [51,83],\"node\": [52],\"in\": [53,213],\"memory.\": [54],\"In\": [55],\"this\": [56,109,177,207],\"paper,\": [57],\"we\": [58,142,256],\"propose\": [59],\"Cluster-GCN,\": [60,255],\"novel\": [62],\"algorithm\": [64,210],\"is\": [66,157,180],\"suitable\": [67],\"by\": [71,98],\"exploiting\": [72],\"clustering\": [75,101],\"structure.\": [76],\"Cluster-GCN\": [77,179,233],\"works\": [78],\"as\": [79],\"following:\": [81],\"at\": [82],\"step,\": [84],\"it\": [85],\"samples\": [86],\"block\": [88],\"nodes\": [90,151],\"associate\": [92],\"dense\": [95],\"subgraph\": [96],\"identified\": [97],\"algorithm,\": [102,141],\"restricts\": [104],\"neighborhood\": [106],\"search\": [107],\"within\": [108],\"subgraph.\": [110],\"This\": [111],\"simple\": [112],\"but\": [113],\"effective\": [114],\"strategy\": [115],\"leads\": [116,248],\"significantly\": [118],\"improved\": [119,250],\"memory\": [120,196,245],\"efficiency\": [123],\"while\": [124,217,267],\"being\": [125],\"able\": [126],\"achieve\": [128,257],\"comparable\": [129],\"test\": [130,136,259],\"accuracy\": [131],\"previous\": [133,165,184,269],\"algorithms.\": [134],\"To\": [135],\"scalability\": [138],\"our\": [140,209],\"create\": [143],\"new\": [145],\"Amazon2M\": [146],\"data\": [147],\"million\": [150,154],\"edges\": [155],\"which\": [156,247],\"more\": [158],\"than\": [159,163,182],\"times\": [161],\"larger\": [162],\"largest\": [166],\"publicly\": [167],\"available\": [168],\"dataset\": [169],\"(Reddit).\": [170],\"For\": [171],\"3-layer\": [174],\"on\": [176,206,263],\"data,\": [178,208],\"faster\": [181],\"state-of-the-art\": [185,258],\"VR-GCN\": [186],\"(1523\": [187],\"seconds\": [188],\"vs\": [189,198],\"seconds)\": [191],\"using\": [193],\"much\": [194,238,242],\"less\": [195],\"(2.2GB\": [197],\"11.2GB).\": [199],\"Furthermore,\": [200,232],\"layer\": [204],\"can\": [211],\"finish\": [212],\"around\": [214],\"minutes\": [216],\"all\": [218],\"existing\": [220],\"fail\": [224],\"train\": [226,237],\"due\": [227],\"out-of-memory\": [230],\"issue.\": [231],\"allows\": [234],\"us\": [235],\"deeper\": [239],\"without\": [241],\"time\": [243],\"overhead,\": [246],\"prediction\": [251],\"accuracy---using\": [252],\"5-layer\": [254],\"F1\": [260],\"score\": [261],\"99.36\": [262],\"PPI\": [265],\"dataset,\": [266],\"best\": [270],\"result\": [271],\"was\": [272],\"98.71\": [273],\"by~\\\\citezhang2018gaan.\": [274]}}", "S": "[ { \"Ty\": 3, \"U\": \"https://arxiv.org/pdf/1905.07953.pdf\" }, { \"Ty\": 1, \"U\": \"https://arxiv.org/abs/1905.07953\" }, { \"Ty\": 1, \"U\": \"https://dblp.uni-trier.de/db/conf/kdd/kdd2019.html#ChiangLSLBH19\" }, { \"Ty\": 1, \"U\": \"https://scirate.com/arxiv/1905.07953\" }, { \"Ty\": 1, \"U\": \"https://ui.adsabs.harvard.edu/abs/2019arXiv190507953C/abstract\" }, { \"Ty\": 1, \"U\": \"https://www.kdd.org/kdd2019/accepted-papers#26\" }, { \"U\": \"https://dl.acm.org/citation.cfm?id=3330925\" } ]", "AA": [ { "DAuN": "Wei-Lin Chiang", "AuN": "weilin chiang", "AuId": 2250130882, "DAfN": "National Taiwan University", "AfN": "national taiwan university", "AfId": 16733864, "S": 1 }, { "DAuN": "Xuanqing Liu", "AuN": "xuanqing liu", "AuId": 2944990871, "DAfN": "University of California, Los Angeles", "AfN": "university of california los angeles", "AfId": 161318765, "S": 2 }, { "DAuN": "Si Si", "AuN": "si si", "AuId": 2099379656, "DAfN": "Google", "AfN": "google", "AfId": 1291425158, "S": 3 }, { "DAuN": "Yang Li", "AuN": "yang li", "AuId": 2294602198, "DAfN": "Google", "AfN": "google", "AfId": 1291425158, "S": 4 }, { "DAuN": "Samy Bengio", "AuN": "samy bengio", "AuId": 2016539005, "DAfN": "Google", "AfN": "google", "AfId": 1291425158, "S": 5 }, { "DAuN": "Cho-Jui Hsieh", "AuN": "chojui hsieh", "AuId": 2148022289, "DAfN": "University of California, Los Angeles", "AfN": "university of california los angeles", "AfId": 161318765, "S": 6 } ], "F": [ { "DFN": "Theoretical computer science", "FN": "theoretical computer science", "FId": 80444323 }, { "DFN": "Semi-supervised learning", "FN": "semi supervised learning", "FId": 58973888 }, { "DFN": "Scalability", "FN": "scalability", "FId": 48044578 }, { "DFN": "Graph", "FN": "graph", "FId": 132525143 }, { "DFN": "F1 score", "FN": "f1 score", "FId": 148524875 }, { "DFN": "Embedding", "FN": "embedding", "FId": 41608201 }, { "DFN": "Deep learning", "FN": "deep learning", "FId": 108583219 }, { "DFN": "Computer science", "FN": "computer science", "FId": 41008148 }, { "DFN": "Clustering coefficient", "FN": "clustering coefficient", "FId": 22047676 }, { "DFN": "Cluster analysis", "FN": "cluster analysis", "FId": 73555534 }, { "DFN": "Artificial intelligence", "FN": "artificial intelligence", "FId": 154945302 } ], "C": { "CN": "kdd", "CId": 1130985203 }, "CI": { "CIN": "kdd 2019", "CIId": 2992576872 } }
{ "logprob": -19.03, "Id": 2951621897, "Ti": "sherlock a deep learning approach to semantic data type detection", "W": ["sherlock","a","deep","learning","approach","to","semantic","data","type","detection"], "AW": ["correctly","detecting","semantic","type","data","columns","crucial","science","tasks","automated","cleaning","schema","matching","discovery","existing","preparation","systems","rely","dictionary","lookups","regular","expression","detect","types","approaches","robust","dirty","limited","number","introduce","sherlock","multi","input","deep","neural","network","train","686","765","retrieved","viznet","corpus","78","dbpedia","column","headers","characterize","matched","1","588","features","describing","statistical","properties","character","distributions","word","embeddings","paragraph","vectors","values","achieves","support","weighted","f","score","0","89","exceeding","machine","learning","baselines","benchmarks","consensus","crowdsourced","annotations"], "Y": 2019, "D": "2019-07-25", "CC": 11, "RId": [2101234009,2250539671,2131744502,102708294,2008896880,2094728533,2151401338,2108223890,2092364718,2064766209,2111869785,2106895292,2028742638,2275294428,2795089200,2255747889,2795302121,1501251778,2522154031,2941366772,2604190938,2798546256,2187252142,2789111643,2407487288], "DN": "Sherlock: A Deep Learning Approach to Semantic Data Type Detection", "DOI": "10.1145/3292500.3330993", "LP": "1508", "FP": "1500", "BK": "KDD", "PB": "ACM", "VSN": "KDD", "IA": "{\"IndexLength\": 142,\"InvertedIndex\": {\"Correctly\": [0],\"detecting\": [1,70],\"the\": [2,82,104,137],\"semantic\": [3,40,71,88],\"type\": [4],\"of\": [5,59,114,123,127,139],\"data\": [6,11,17,22,25,52,78],\"columns\": [7,79],\"is\": [8],\"crucial\": [9],\"for\": [10,69],\"science\": [12],\"tasks\": [13],\"such\": [14],\"as\": [15],\"automated\": [16],\"cleaning,\": [18],\"schema\": [19],\"matching,\": [20],\"and\": [21,27,34,53,111,132,136],\"discovery.\": [23],\"Existing\": [24],\"preparation\": [26],\"analysis\": [28],\"systems\": [29],\"rely\": [30],\"on\": [31,76],\"dictionary\": [32,131],\"lookups\": [33],\"regular\": [35,133],\"expression\": [36,134],\"matching\": [37,86],\"to\": [38,50,92],\"detect\": [39,55],\"types.\": [41,60,72],\"However,\": [42],\"these\": [43],\"matching-based\": [44],\"approaches\": [45],\"often\": [46],\"are\": [47],\"not\": [48],\"robust\": [49],\"dirty\": [51],\"only\": [54],\"a\": [56,64,119],\"limited\": [57],\"number\": [58],\"We\": [61,73,95],\"introduce\": [62],\"Sherlock,\": [63],\"multi-input\": [65],\"deep\": [66],\"neural\": [67],\"network\": [68],\"train\": [74],\"Sherlock\": [75,117],\"$686,765$\": [77],\"retrieved\": [80],\"from\": [81,90],\"VizNet\": [83],\"corpus\": [84],\"by\": [85],\"$78$\": [87],\"types\": [89],\"DBpedia\": [91],\"column\": [93,99,115],\"headers.\": [94],\"characterize\": [96],\"each\": [97],\"matched\": [98],\"with\": [100],\"$1,588$\": [101],\"features\": [102],\"describing\": [103],\"statistical\": [105],\"properties,\": [106],\"character\": [107],\"distributions,\": [108],\"word\": [109],\"embeddings,\": [110],\"paragraph\": [112],\"vectors\": [113],\"values.\": [116],\"achieves\": [118],\"support-weighted\": [120],\"F$_1$\": [121],\"score\": [122],\"$0.89$,\": [124],\"exceeding\": [125],\"that\": [126],\"machine\": [128],\"learning\": [129],\"baselines,\": [130],\"benchmarks,\": [135],\"consensus\": [138],\"crowdsourced\": [140],\"annotations.\": [141]}}", "S": "[ { \"Ty\": 1, \"U\": \"https://dblp.uni-trier.de/db/conf/kdd/kdd2019.html#HulsebosHBZSKDH19\" }, { \"Ty\": 1, \"U\": \"https://dl.acm.org/citation.cfm?id=3330993\" }, { \"Ty\": 1, \"U\": \"https://doi.org/10.1145/3292500.3330993\" }, { \"Ty\": 1, \"U\": \"https://www.kdd.org/kdd2019/accepted-papers#150\" }, { \"U\": \"http://doi.org/10.1145/3292500.3330993\" } ]", "AA": [ { "DAuN": "Madelon Hulsebos", "AuN": "madelon hulsebos", "AuId": 2945167634, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 1 }, { "DAuN": "Kevin Hu", "AuN": "kevin hu", "AuId": 2169178449, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 2 }, { "DAuN": "Michiel Bakker", "AuN": "michiel a bakker", "AuId": 2886122990, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 3 }, { "DAuN": "Emanuel Zgraggen", "AuN": "emanuel zgraggen", "AuId": 1770674175, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 4 }, { "DAuN": "Arvind Satyanarayan", "AuN": "arvind satyanarayan", "AuId": 2022576506, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 5 }, { "DAuN": "Tim Kraska", "AuN": "tim kraska", "AuId": 2078839115, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 6 }, { "DAuN": "Çagatay Demiralp", "AuN": "cagatay demiralp", "AuId": 2000216820, "DAfN": "Megagon Labs, Mountain View, CA, USA", "S": 7 }, { "DAuN": "César Hidalgo", "AuN": "cesar a hidalgo", "AuId": 2152661887, "DAfN": "Massachusetts Institute of Technology", "AfN": "massachusetts institute of technology", "AfId": 63966007, "S": 8 } ], "F": [ { "DFN": "Semantic data model", "FN": "semantic data model", "FId": 90312973 }, { "DFN": "Schema matching", "FN": "schema matching", "FId": 2777327318 }, { "DFN": "Regular expression", "FN": "regular expression", "FId": 121329065 }, { "DFN": "Paragraph", "FN": "paragraph", "FId": 2777206241 }, { "DFN": "Natural language processing", "FN": "natural language processing", "FId": 204321447 }, { "DFN": "Dirty data", "FN": "dirty data", "FId": 180235380 }, { "DFN": "Deep learning", "FN": "deep learning", "FId": 108583219 }, { "DFN": "Data discovery", "FN": "data discovery", "FId": 2777516300 }, { "DFN": "Computer science", "FN": "computer science", "FId": 41008148 }, { "DFN": "Artificial neural network", "FN": "artificial neural network", "FId": 50644808 }, { "DFN": "Artificial intelligence", "FN": "artificial intelligence", "FId": 154945302 } ], "C": { "CN": "kdd", "CId": 1130985203 }, "CI": { "CIN": "kdd 2019", "CIId": 2992576872 } }
```

## Create index

Open a Windows command prompt (cmd.exe), navigate to the directory where you installed (unzipped) the KESM command line tool and execute the following command:

```cmd
Kesm.exe BuildIndexLocal --SchemaFilePath schema.json --EntitiesFilePath data.txt --OutputIndexFilePath index
```

## Test index

Verify that your index works by executing the following two commands and comparing their output with the sample output below.

### Test evaluate command

Command:

```cmd
Kesm.exe Evaluate --KesQueryExpression "Composite(F.FN='deep learning')" --Attributes "Id,Ti,F.FN" --IndexFilePaths index
```

Output:

```json
{
    "expr": "Composite(F.FN='deep learning')",
    "entities": [{
        "logprob": -18.942,
        "prob": 5.9373674E-09,
        "Id": 2945827377,
        "Ti": "cluster gcn an efficient algorithm for training deep and large graph convolutional networks",
        "F": [{
            "FN": "theoretical computer science"
        }, {
            "FN": "semi supervised learning"
        }, {
            "FN": "scalability"
        }, {
            "FN": "graph"
        }, {
            "FN": "f1 score"
        }, {
            "FN": "embedding"
        }, {
            "FN": "deep learning"
        }, {
            "FN": "computer science"
        }, {
            "FN": "clustering coefficient"
        }, {
            "FN": "cluster analysis"
        }, {
            "FN": "artificial intelligence"
        }]
    }, {
        "logprob": -19.03,
        "prob": 5.4372088E-09,
        "Id": 2951621897,
        "Ti": "sherlock a deep learning approach to semantic data type detection",
        "F": [{
            "FN": "semantic data model"
        }, {
            "FN": "schema matching"
        }, {
            "FN": "regular expression"
        }, {
            "FN": "paragraph"
        }, {
            "FN": "natural language processing"
        }, {
            "FN": "dirty data"
        }, {
            "FN": "deep learning"
        }, {
            "FN": "data discovery"
        }, {
            "FN": "computer science"
        }, {
            "FN": "artificial neural network"
        }, {
            "FN": "artificial intelligence"
        }]
    }],
    "timed_out": false
}
```

### Test histogram command

Command:

```cmd
Kesm.exe Histogram Evaluate --KesQueryExpression "Composite(F.FN='deep learning')" --Attributes "F.FN" --IndexFilePaths index
```

Output:

```json
{
    "expr": "Composite(F.FN='deep learning')",
    "num_entities": 2,
    "histograms": [{
        "attribute": "F.FN",
        "distinct_values": 19,
        "total_count": 22,
        "histogram": [{
            "value": "artificial intelligence",
            "logprob": -18.2918851316,
            "count": 2
        }, {
            "value": "computer science",
            "logprob": -18.2918851316,
            "count": 2
        }, {
            "value": "deep learning",
            "logprob": -18.2918851316,
            "count": 2
        }, {
            "value": "graph",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "cluster analysis",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "clustering coefficient",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "embedding",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "f1 score",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "scalability",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "semi supervised learning",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "theoretical computer science",
            "logprob": -18.942,
            "count": 1
        }, {
            "value": "artificial neural network",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "data discovery",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "dirty data",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "natural language processing",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "paragraph",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "regular expression",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "schema matching",
            "logprob": -19.03,
            "count": 1
        }, {
            "value": "semantic data model",
            "logprob": -19.03,
            "count": 1
        }]
    }],
    "timed_out": false
}
```

## Next steps

Advance to the next section to learn how to create a MAKES grammar, used for interpreting natural language queries with the [Interpret API](reference-get-interpret.md).

> [!div class="nextstepaction"]
>[Define grammar](how-to-grammar.md)