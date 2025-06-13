locals {
    capacities = { for c in var.fabric_capacities : c.basename => c }
    workspaces = var.workspaces
}

module "fabric_capacity" {
    for_each    = local.capacities
    source      = "./modules/fabric_capacity"
    location    = each.value.location
    basename    = each.value.basename
    sku         = each.value.sku
    admin_email = each.value.admin_email

    providers = {
        azurerm = azurerm
        azuread = azuread
    }
}

module "fabric_workspace" {
    for_each      = { for ws in local.workspaces : ws.display_name => ws }
    source        = "./modules/fabric_workspace"
    display_name  = each.value.display_name
    description   = each.value.description
    capacity_id   = module.fabric_capacity[each.value.capacity_basename].id
    depends_on    = [module.fabric_capacity]
}
