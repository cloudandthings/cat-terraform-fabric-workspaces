terraform {
  required_providers {
    azurerm = {
      version = "= 3.70.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }    
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}