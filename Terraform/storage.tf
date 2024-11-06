provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Resource group for the storage account
resource "azurerm_resource_group" "rg-tfstate" {
  name     = "rg-tfstate-hylastik-project"
  location = "East US"  # Change location as needed
}

# This file to show how to create storage account with terraform  where we can store our state-file
# Storage account for Terraform state
resource "azurerm_storage_account" "storage-state-file" {
  name                     = "tfstate-hylastik-project"
  resource_group_name      = azurerm_resource_group.rg-tfstate.name
  location                 = azurerm_resource_group.rg-tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Container for storing the state file
resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage-state-file.name
  container_access_type = "private"
}

