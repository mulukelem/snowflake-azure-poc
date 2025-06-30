Snowflake + Azure Blob Storage Integration POC (Integrated SAS Option)

🎯 Overview

This tutorial guides you step by step to connect Azure Blob Storage to Snowflake, load data, and query it. It includes both methods: using Storage Integration or SAS Token, with CLI/SQL commands and a schematic diagram.

💡 Azure Setup

1️⃣ Create resource group

az group create --name soltest-rg --location eastus

2️⃣ Create storage account

az storage account create --name solteststorage --resource-group soltest-rg --location eastus --sku Standard_LRS

3️⃣ Create blob container

az storage container create --account-name solteststorage --name soltestcontainer --public-access off

4️⃣ Upload CSV file

az storage blob upload --account-name solteststorage --container-name soltestcontainer --name azure_blob_sample.csv --file path/to/azure_blob_sample.csv

5️⃣ Enable public network access

In Azure portal → Storage account → Networking → set Public network access to "Enabled from all networks" (for this tutorial).

💡 Snowflake Setup

6️⃣ Create Warehouse

Definition: A warehouse is a compute resource in Snowflake that performs queries, loads, and other data operations.

CREATE OR REPLACE WAREHOUSE COMPUTE_WH WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;

7️⃣ Create Database

Definition: A logical container for schemas, tables, views, etc.

CREATE OR REPLACE DATABASE TUTORIAL_DB;
USE DATABASE TUTORIAL_DB;

8️⃣ Create Schema

Definition: A namespace within a database to organize objects.

CREATE OR REPLACE SCHEMA PUBLIC;
USE SCHEMA PUBLIC;

9️⃣ Create Table

Definition: Where your structured data will be stored after loading from blob storage.

CREATE OR REPLACE TABLE users (
  id INT,
  name STRING,
  email STRING
);

Option A: Using Storage Integration (Recommended for production)

🔟 Create Storage Integration

Definition: An object that stores credentials and configuration to securely connect Snowflake to external storage.

CREATE OR REPLACE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('azure://solteststorage.blob.core.windows.net/soltestcontainer/');

After this, run:

DESC INTEGRATION azure_int;

Copy AZURE_CLIENT_ID and AZURE_TENANT_ID, and assign the Storage Blob Data Contributor role in Azure IAM to this client ID.

1️⃣1️⃣ Create Stage (Storage Integration)

CREATE OR REPLACE STAGE azure_stage
  URL = 'azure://solteststorage.blob.core.windows.net/soltestcontainer/'
  STORAGE_INTEGRATION = azure_int;

Option B: Using SAS Token (Quick Setup)

🔁 Alternative Stage Setup with SAS Token

CREATE OR REPLACE STAGE azure_stage
  URL = 'azure://solteststorage.blob.core.windows.net/soltestcontainer'
  CREDENTIALS = (AZURE_SAS_TOKEN = '<your-SAS-token>');

⚠️ You must generate a valid SAS token in Azure Portal or CLI, and replace <your-SAS-token> above.

TEST SAS TOKEN AS BELOW:
## Testing the SAS Token

After generating the SAS token, you can test it by accessing a blob in your Azure storage container. Follow these steps:

1. **Construct the Blob URL with SAS Token**

   Format:
   ```
   https://<storage_account>.blob.core.windows.net/<container>/<blob>?<sas_token>
   ```

   Example:
   ```
   https://solteststorage.blob.core.windows.net/soltestcontainer/azure_blob_sample.csv?<sas_token>
   ```

2. **Test Download with `curl`**

   Run the following command in your terminal:
   ```sh
   curl "<full_blob_url_with_sas_token>" -o downloaded.csv
   ```

   If the SAS token is valid and has read permissions, the file will be downloaded as `downloaded.csv`.

3. **Test in Browser (Optional)**

   Paste the full URL (including the SAS token) into your browser's address bar. If the SAS token is valid and has read permissions, the file will download or display in the browser.

4. **Test Upload with Azure CLI (If Write Permission is Granted)**

   You can upload a file using the SAS token:
   ```sh
   az storage blob upload \
     --container-name <container> \
     --name <blob_name> \
     --file <local_file_path> \
     --account-name <storage_account> \
     --sas-token "<sas_token>"
   ```

   Replace `<container>`, `<blob_name>`, `<local_file_path>`, `<storage_account>`, and `<sas_token>` with your actual values.

---
```// filepath: c:\Users\user\snowflake-azure-poc\README.md

## Testing the SAS Token

After generating the SAS token, you can test it by accessing a blob in your Azure storage container. Follow these steps:

1. **Construct the Blob URL with SAS Token**

   Format:
   ```
   https://<storage_account>.blob.core.windows.net/<container>/<blob>?<sas_token>
   ```

   Example:
   ```
   https://solteststorage.blob.core.windows.net/soltestcontainer/azure_blob_sample.csv?<sas_token>
   ```

2. **Test Download with `curl`**

   Run the following command in your terminal:
   ```sh
   curl "<full_blob_url_with_sas_token>" -o downloaded.csv
   ```

   If the SAS token is valid and has read permissions, the file will be downloaded as `downloaded.csv`.

3. **Test in Browser (Optional)**

   Paste the full URL (including the SAS token) into your browser's address bar. If the SAS token is valid and has read permissions, the file will download or display in the browser.

   

🔍 Verify Stage Access

LIST @azure_stage;

💡 Load and Query Data

1️⃣2️⃣ Load data into table

COPY INTO users
FROM @azure_stage/azure_blob_sample.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

1️⃣3️⃣ Query the data

SELECT * FROM users;

💡 Clean Up (optional)

Delete Azure resources to avoid charges:

az group delete --name soltest-rg --yes --no-wait

🗺️ Schematic Diagram

┌────────────────────────────┐
│      Azure Portal          │
│  ┌───────────────────────┐ │
│  │ Resource Group        │ │
│  │  └── Storage Account  │ │
│  │        └── Container  │ │
│  │            └── CSV    │ │
│  └───────────────────────┘ │
└─────────────┬──────────────┘
              │ (blob storage + IAM role or SAS)
              │
        ┌─────▼───────┐
        │ Snowflake   │
        │  ┌────────┐ │
        │  │Storage │ │
        │  │Integration │ (optional)
        │  └────────┘ │
        │  ┌─────────────┐
        │  │ Stage       │
        │  └─────────────┘
        │  ┌─────────────┐
        │  │ Table       │
        │  └─────────────┘
        │  ┌─────────────┐
        │  │ Warehouse   │
        │  └─────────────┘
        └─────┬───────┘
              │
       ┌──────▼───────┐
       │ COPY INTO &  │
       │ SELECT Query │
       └──────────────┘

✅ Summary

You now have an end-to-end flow: Azure setup → Snowflake setup → Load → Query → Verify.

You can choose between Storage Integration (more secure, long term) or SAS token (quick, simple).

Includes all SQL and CLI needed to reproduce the setup, plus a schematic.

