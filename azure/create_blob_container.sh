#!/bin/bash

# This script creates a blob container in the specified storage account.

STORAGE_ACCOUNT_NAME="solteststorage"
CONTAINER_NAME="soltestcontainer"

az storage container create --account-name $STORAGE_ACCOUNT_NAME --name $CONTAINER_NAME --public-access off

echo "Blob container '$CONTAINER_NAME' created in storage account '$STORAGE_ACCOUNT_NAME'."