#!/bin/bash

# This script generates a SAS token for the specified Azure Blob Storage container.

# Variables
RESOURCE_GROUP_NAME="soltest-rg"
STORAGE_ACCOUNT_NAME="solteststorage"
CONTAINER_NAME="soltestcontainer"
EXPIRY_DATE=$(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ') # 1 day from now

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP_NAME \
  --account-name $STORAGE_ACCOUNT_NAME \
  --query '[0].value' -o tsv)

# Generate SAS token
SAS_TOKEN=$(az storage container generate-sas \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $ACCOUNT_KEY \
  --name $CONTAINER_NAME \
  --permissions rwl \
  --expiry $EXPIRY_DATE \
  -o tsv)

echo "SAS Token:"
echo "$SAS_TOKEN"