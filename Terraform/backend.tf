terraform {
  required_version = ">= 1.5.0, < 2.0.0"  
# I manually created the resource group, storage account, and container from the Azure portal to store the state file.   
  backend "azurerm" {
    resource_group_name   = "rg-terraform-backend"
    storage_account_name  = "tfstatelu54mz"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}