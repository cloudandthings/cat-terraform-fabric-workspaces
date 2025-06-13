data "azurerm_client_config" "current" {}

data "azuread_user" "admin" {
  user_principal_name = var.admin_email
}

resource "azurerm_resource_group" "this" {
  name     = var.basename
  location = var.location
}

resource "azurerm_fabric_capacity" "this" {
  name                = var.basename
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  administration_members = [var.admin_email]

  sku {
    name = var.sku
    tier = "Fabric"
  }

  tags = {
    environment = "test"
  }
}