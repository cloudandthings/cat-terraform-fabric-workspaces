terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
<<<<<<< HEAD
      version = "1.8.0"
=======
      version = "1.6.0"
>>>>>>> b07b7af (feat: 2026-4-24 Add new Features)
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