---
title: Processing Microsoft Academic Graph using PySpark
description: Step-by-step instructions to process Microsoft Academic Graph using PySpark
ms.topic: get-started-article
ms.date: 11/08/2018
---
# Processing Microsoft Academic Graph using PySpark 

You could use PySpark to process Microsoft Academic Graph stored in Azure Storage. Here are the step-by-step instructions.

1. Create Azure HDInsight/Spark cluster.
1. Running PySpark in HDInsight/Spark cluster.

## Create Azure HDInsight/Spark cluster

1. Create an Azure HDInsight cluster. From Azure portal Home > Create a resource > Analytics > HDInsight

    ![Create new Azure HDInsight resource](media/create-hdinsight-select.png "Create new Azure HDInsight resource")

1. Configure HDInsight/Spark cluster. Choose "Spark" as the cluster type.

    ![Configure HDInsight/Spark cluster](media/create-spark-cluster-1.png "Configure HDInsight/Spark cluster")

1. Create an Azure Storage and choose a default container as the primary storage for HDInsight/Spark cluster.

    ![Configure primary storage](media/create-spark-cluster-2.png "Configure primary storage")

1. Optional: If Add Azure Storage account containing MAG as additional storage.

    ![Configure additional storage](media/create-spark-cluster-3.png "Configure additional storage")

1. Optional: Change HDInsight/Spark cluster size.

    ![Change cluster size](media/create-spark-cluster-4.png "Change cluster size")

## Running PySpark in HDInsight/Spark cluster

There are two options to use Microsoft Academic Graph in Azure HDInsight.

1. Attach the Azure storage storing Microsoft Academic Graph to Azure HDInsight (see Step 2 above) and load the graph data with load path (e.g. `/mag/Affiliations.txt`).

1. Without attaching the Azure storage storing Microsoft Academic Graph to Azure HDInsight, using the network file path to the Azure storage and pattern is `wasbs://<container-name>@<storage-name>.blob.core.windows.net/<path/to/file>` (e.g. `wasbs://mag-2018-11-09@microsoftacademicgraph.blob.core.windows.net/mag/Affiliations.txt`).
