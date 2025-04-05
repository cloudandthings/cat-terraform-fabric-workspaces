module "fabric_environment" {
  source = "./modules/fabric_environment"
  workspace_id = var.fabric_provider.workspace_id
  display_name = var.fabric_environment.display_name
  description  = var.fabric_environment.description

  providers = {
    fabric = fabric
  }  
}

module "fabric_notebooks" {
  source = "./modules/fabric_notebook"
  tenant_id     = var.fabric_provider.tenant_id
  client_id     = var.fabric_provider.client_id
  client_secret = var.fabric_provider.client_secret
  workspace_id = var.fabric_provider.workspace_id

  for_each = { for idx, notebook in var.fabric_notebooks : idx => notebook }
  
  display_name = each.value.display_name
  description  = each.value.description
  local_file_path = each.value.local_file_path

  providers = {
    fabric = fabric
  }
}