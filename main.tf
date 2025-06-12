module "fabric_capacity" {
  source                      = "./modules/fabric_capacity"
  location                    = var.fabric_capacity.location
  basename                    = var.fabric_capacity.basename
  sku                         = var.fabric_capacity.sku
  admin_email                 = var.fabric_capacity.admin_email
}

module "fabric_workspace" {
  source                      = "./modules/fabric_workspace"
  display_name                = var.workspace.display_name
  description                 = var.workspace.description
  capacity_id                 = module.fabric_capacity.id
  depends_on                  = [ module.fabric_capacity ]
}

