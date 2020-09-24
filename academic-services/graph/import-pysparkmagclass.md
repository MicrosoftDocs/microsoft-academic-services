---
title: 'Import PySparkMagClass'
description: Import PySparkMagClass Notebook
services: microsoft-academic-services
ms.topic: tutorial
ms.service: microsoft-academic-services
ms.date: 9/23/2020
---
# Import PySparkMagClass (PySpark)

## Import PySparkMagClass.py as a shared notebook

In this section, you import PySparkMagClass.py as a shared notebook in Azure Databricks workspace. You could run this utility notebook from other notebooks later.

1. Save samples\PySparkMagClass.py in MAG dataset to local drive.

1. In the [Azure portal](https://portal.azure.com), go to the Azure Databricks service that you created, and select **Launch Workspace**.

1. On the left, select **Workspace**. From the **Workspace** > **Shared** drop-down, select **Import**.

    ![Import a notebook in Databricks](media/databricks/import-shared-notebook.png "import notebook in Databricks")
    
1. Drag and drop PySparkMagClass.py to the **Import Notebook** dialog box

    ![Provide details for a notebook in Databricks](media/databricks/import-notebook-dialog.png "Provide details for a notebook in Databricks")

1. Select **Import**. This will create a notebook with path `"/Shared/PySparkMagClass"`. No need to run this notebook.

   > [!NOTE]
   > When importing this notebook under **Shared** folder. The full path of this notebook is `"/Shared/PySparkMagClass"`. If you import it under other folders, note the actual full path and use it in following sections.

## Resources

* [Import a notebook and attach it to the cluster](https://docs.databricks.com/user-guide/notebooks/notebook-manage.html#import-a-notebook).
