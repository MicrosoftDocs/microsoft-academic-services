---
title: Microsoft Academic Graph using PySpark
description: Step-by-step instructions to process Microsoft Academic Graph using PySpark
ms.topic: get-started-article
ms.date: 11/08/2018
---
# Using Microsoft Academic Graph with PySpark on Azure HDInsight/Spark cluster

You could use PySpark to process Microsoft Academic Graph stored in Azure Storage. Here are the step-by-step instructions.

1. Create Azure HDInsight/Spark cluster.
1. Referencing MAG files in PySpark scripts.

## Create Azure HDInsight/Spark cluster

1. Create an Azure HDInsight cluster. From Azure portal Home > Create a resource > Analytics > HDInsight

    ![Create new Azure HDInsight resource](media/create-hdinsight-select.png "Create new Azure HDInsight resource")

1. Configure HDInsight/Spark cluster. Choose "Spark" as the cluster type.

    ![Configure HDInsight/Spark cluster](media/create-spark-cluster-1.png "Configure HDInsight/Spark cluster")

1. Configure primary storage. Create an Azure Storage account and choose a default container as the primary storage.

    ![Configure primary storage](media/create-spark-cluster-2.png "Configure primary storage")

1. Configure additional storage. Add Azure Storage account containing MAG as an additional storage account if it is not the same storage account in the previous step.

    ![Configure additional storage](media/create-spark-cluster-3.png "Configure additional storage")

1. Create HDInsight/Spark cluster. Optionally change cluster size before clicking the "Create" buttom.

    ![Create cluster](media/create-spark-cluster-4.png "Create cluster")

## Referencing Microsoft Academic Graph files in PySpark scripts

The uri pattern for referencing Microsoft Academic Graph files is `wasbs://<container-name>@<storage-name>.blob.core.windows.net/<file-path>`. (e.g. `wasbs://mag-2018-11-09@mymagstorage.blob.core.windows.net/mag/Affiliations.txt`).
