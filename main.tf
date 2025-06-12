module "fabric_workspace" {
  source                      = "./modules/fabric_workspace"
  display_name         = var.workspace.display_name
  description                    = var.workspace.description
}
