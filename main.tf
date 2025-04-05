module "fabric_notebooks" {
  source = "./modules/fabric_notebook"
  tenant_id     = var.fabric_provider.tenant_id
  client_id     = var.fabric_provider.client_id
  client_secret = var.fabric_provider.client_secret

  for_each = { for idx, notebook in var.fabric_notebooks : idx => notebook }

  workspace_id = each.value.workspace_id
  display_name = each.value.display_name

  # Pass the provider configuration
  providers = {
    fabric = fabric
  }
}