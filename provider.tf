terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "1.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.98.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.47.0"
    }
  }
}

provider "fabric" {
  tenant_id     = var.fabric_provider.tenant_id
  use_cli       = true
  preview       = true
}

provider "azurerm" {
  features {}
  subscription_id = var.fabric_provider.subscription_id
}

provider "azuread" {
  tenant_id = var.fabric_provider.tenant_id
}