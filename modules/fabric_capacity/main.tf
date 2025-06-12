module "fabric_capacity" {
  source            = "github.com/Azure/azure-data-labs-modules/terraform/fabric/fabric-capacity"

  basename          = "${var.basename}"
  resource_group_id = module.resource_group.id
  location          = var.location

  sku               = var.sku
  admin_email       = var.admin_email
}

module "resource_group" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/resource-group"

  basename = "${var.basename}"
  location = var.location
}