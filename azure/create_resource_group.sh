#!/bin/bash

# This script creates an Azure resource group using the Azure CLI.

RESOURCE_GROUP_NAME="soltest-rg"
LOCATION="eastus"

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

echo "Resource group '$RESOURCE_GROUP_NAME' created in location '$LOCATION'."