---
title: 'Import MagClass'
description: Import MagClass Notebook
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# Import MagClass (PySpark)

## Import MagClass.py notebook

In this section, you will import the MagClass.py notebook to Azure Databricks workspace.
It defines MicrosoftAcademicGraph class for accessing MAG data.
You will run this utility notebook from other notebooks later.

1. Download `samples/pyspark/MagClass.py` in MAG dataset to your local drive.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Databricks service that you created, and select **Launch Workspace**.

1. On the left, select **Workspace**. From **Workspace** > **Users** > **Your folder** drop-down, select **Import**.

    ![Import a notebook in Databricks](media/databricks/import-notebook-menu.png "import notebook in Databricks")
    
1. Drag and drop `MagClass.py` to the **Import Notebook** dialog box

    ![Provide details for a notebook in Databricks](media/databricks/import-notebook-dialog.png "Provide details for a notebook in Databricks")

1. Select **Import**. This will create a notebook with path `"./MagClass"`. No need to run this notebook.

## Resources

* [Import a notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook).
