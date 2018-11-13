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

    ![Create new Azure HDInsight account](media/create-hdinsight-select.png "Create new Azure HDInsight account")

1. Configure HDInsight/Spark cluster. Choose "Spark" as the cluster type.

    ![Enter details for new Azure HDInsight account](media/create-hdinsight-account-details.png "Enter details for new Azure HDInsight account")

1. Create an Azure Storage account and a default container as the default storage device for HDInsight/Spark cluster.

    ![Enter details for new storage for new Azure HDInsight account](media/create-hdinsight-storage-account-details.png "Enter details for new storage for new Azure HDInsight account")

## Configure Azure HDInsight to use Microsoft Academic Graph

There are two options to use Microsoft Academic Graph in Azure HDInsight.

1. Attach the Azure storage storing Microsoft Academic Graph to Azure HDInsight (see Step 2 above) and load the graph data with load path (e.g. `/mag/Affiliations.txt`).

1. Without attaching the Azure storage storing Microsoft Academic Graph to Azure HDInsight, using the network file path to the Azure storage and pattern is `wasbs://<container-name>@<storage-name>.blob.core.windows.net/<path/to/file>` (e.g. `wasbs://mag-2018-11-09@microsoftacademicgraph.blob.core.windows.net/mag/Affiliations.txt`).
