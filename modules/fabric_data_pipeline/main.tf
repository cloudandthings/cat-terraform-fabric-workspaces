resource "fabric_data_pipeline" "data_pipeline" {
  display_name              = var.display_name
  description               = var.description
  workspace_id              = var.workspace_id
  format                    = "Default"
  definition_update_enabled = true
  definition = {
    "pipeline-content.json" = {
      source = var.local_file_path
    }
  }
}