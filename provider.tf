terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "1.0.0"
    }
  }
}

provider "fabric" {
  tenant_id     = var.fabric_provider.tenant_id
  client_id     = var.fabric_provider.client_id
  client_secret = var.fabric_provider.client_secret
  preview       = true
}