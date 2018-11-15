---
title: Microsoft Academic Graph using HDInsight/Spark
description: Set up Azure HDInsight/Spark cluster for Microsoft Academic Graph
ms.topic: get-started-article
ms.date: 11/15/2018
---
# Set up Azure HDInsight/Spark cluster for Microsoft Academic Graph

You could use PySpark to process Microsoft Academic Graph stored in Azure Storage. Here are the step-by-step instructions.

1. Create Azure HDInsight/Spark cluster.
1. Referencing MAG files in PySpark scripts.

## Create Azure HDInsight/Spark cluster

1. Create an Azure HDInsight cluster. From Azure portal Home > Create a resource > Analytics > HDInsight

    ![Create new Azure HDInsight resource](media/create-hdinsight-select.png "Create new Azure HDInsight resource")

1. Configure HDInsight/Spark cluster. Choose "Spark" as the cluster type.

    ![Configure HDInsight/Spark cluster](media/create-spark-cluster-1.png "Configure HDInsight/Spark cluster")

1. Configure primary storage. Create an Azure Storage account and choose a default container as the primary storage.

    ![Configure HDInsight/Spark primary storage](media/create-spark-cluster-2.png "Configure HDInsight/Spark primary storage")

1. Configure additional storage. Add Azure Storage account containing MAG as an additional storage account if it is not the same storage account in the previous step.

    ![Configure HDInsight/Spark additional storage](media/create-spark-cluster-3.png "Configure HDInsight/Spark additional storage")

1. Create HDInsight/Spark cluster. Optionally change cluster size before clicking the "Create" buttom.

    ![Change cluster size and create cluster](media/create-spark-cluster-4.png "Change cluster size and create cluster")

## Referencing Microsoft Academic Graph files in PySpark scripts

The uri pattern for referencing Microsoft Academic Graph files is `wasbs://<container-name>@<storage-name>.blob.core.windows.net/<file-path>`. (e.g. `wasbs://mag-2018-11-09@mymagstorage.blob.core.windows.net/mag/Affiliations.txt`).
