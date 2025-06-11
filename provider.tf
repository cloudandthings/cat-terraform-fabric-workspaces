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
  use_msi       = true
  preview       = true
}