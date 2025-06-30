#!/bin/bash

# This script uploads a sample CSV file to the Azure blob container.

STORAGE_ACCOUNT_NAME="solteststorage"
CONTAINER_NAME="soltestcontainer"
BLOB_NAME="azure_blob_sample.csv"
LOCAL_FILE_PATH="../csv/azure_blob_sample.csv"

az storage blob upload --account-name $STORAGE_ACCOUNT_NAME --container-name $CONTAINER_NAME --name $BLOB_NAME --file $LOCAL_FILE_PATH

echo "File '$LOCAL_FILE_PATH' uploaded as blob '$BLOB_NAME' in container '$CONTAINER_NAME'."