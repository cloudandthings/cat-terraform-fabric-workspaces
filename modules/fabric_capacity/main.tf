resource "azurerm_resource_group" "this" {
  name     = var.basename
  location = var.location
}

resource "azurerm_fabric_capacity" "this" {
  name                = var.basename
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location

  administration_members = var.admin_emails

  sku {
    name = var.sku
    tier = "Fabric"
  }

  tags = {
    environment = "test"
  }
}