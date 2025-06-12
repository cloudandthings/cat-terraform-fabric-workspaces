terraform {
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "1.2.0"
    }
  }
}

provider "fabric" {
  tenant_id     = var.fabric_provider.tenant_id
  use_cli       = true
  preview       = true
}