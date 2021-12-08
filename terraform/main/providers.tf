terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = ">= 2.28"
  }
  backend "azurerm" {
    resource_group_name  = "cloudmatoslabtfstate"
    storage_account_name = "cloudmatostfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}