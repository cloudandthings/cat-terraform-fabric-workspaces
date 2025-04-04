# We strongly recommend using the required_providers block to set the Fabric Provider source and version being used
terraform {
  required_version = ">= 1.8, < 2.0"
  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "1.0.0" # Check for the latest version on the Terraform Registry
    }
  }
}

# Configure the Microsoft Fabric Provider
provider "fabric" {
    tenant_id     = var.tenant_id
    client_id     = var.client_id
    client_secret = var.client_secret
}

resource "fabric_notebook" "example_by_name" {
    display_name = "terraform-example"
    workspace_id = var.workspace_id
}