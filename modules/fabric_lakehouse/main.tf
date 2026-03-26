resource "fabric_lakehouse" "lakehouse" {
  display_name = var.display_name
  description  = var.description
  workspace_id = var.workspace_id

  configuration = {
    enable_schemas = var.enable_schemas
  }
}