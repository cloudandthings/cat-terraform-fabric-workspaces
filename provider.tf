terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "1.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.70.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
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
  skip_provider_registration = true
}