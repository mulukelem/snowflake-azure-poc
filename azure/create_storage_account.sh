#!/bin/bash

# This script creates an Azure storage account.

RESOURCE_GROUP_NAME="soltest-rg"
STORAGE_ACCOUNT_NAME="solteststorage"
LOCATION="eastus"

az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION --sku Standard_LRS

echo "Storage account '$STORAGE_ACCOUNT_NAME' created in resource group '$RESOURCE_GROUP_NAME'."