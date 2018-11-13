---
title: PySpark Analytics samples for Microsoft Academic Graph
description: Illustrates how to perform analytics for Microsoft Academic Graph using HDInsight
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 11/08/2018
---
# PySpark analytics samples for Microsoft Academic Graph

Illustrates how to perform analytics for Microsoft Academic Graph using PySpark on HDInsight/Spark cluster.

## Sample projects

* [Extract Affiliation ID for Affiliation-A](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab1_ExtractAffiliation.py)
* [Join all Conferences and Journals as Venues](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab2_UnionVenues.py)
* [Get all publications from Affiliation-A](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab3_JoinPaperAuthorAffiliation.py)
* [Get all author names from the publications from Affiliation-A and publications' details](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab4_CreateTable_Extract.py)
* [Get all Field-Of-Studies for Affiliation-A](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab5_CreateTableByTvf.py)
* [Get all collaborated affiliations of Affiliation-A using publications from Affiliation-A](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab6_GetPartnerData.py)
* [Get publication count and citation sum for each year](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples/blob/master/src/Lab7_GroupByYear.py)

## Getting started with sample projects

### Pre-requisites

* [Geting Microsoft Academic Graph on Azure storage](get-started-setup-provisioning.md)
* [Using Microsoft Academic Graph with PySpark on Azure HDInsight/Spark](get-started-setup-azure-hdinsight.md)

### Quick-start

1. Download or clone the [samples repository](https://github.com/Azure-Samples/microsoft-academic-graph-pyspark-samples)
4. For each tutorial there should be: A Python script(.py).

## Working with PySpark scripts on Azure HDInsight

* How to run PySpark scripts
  * Login the HDInsight with ssh

    ![Login the HDInsigth with ssh](media/samples-login-hdinsight.png "Login the HDInsigth with ssh")

  * Make sure the script file is available on HDInsight already. Run the script with python command.

    ![Run Python script in terminal](media/samples-run-pyspark-script.png "Run Python script in terminal")

* How to view results in Azure data explorer

    ![View PySpark result with data explorer](media/samples-view-pyspark-script-results.png "View PySpark result with data explorer")

## Resources

* [Apache Spark in Azure HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/spark/apache-spark-overview
)
* [Analyze Spark data using Power BI in HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/spark/apache-spark-overview
)
* [Apache Spark Documentation](http://spark.apache.org/docs/2.3.0/)
