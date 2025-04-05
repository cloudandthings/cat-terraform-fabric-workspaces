resource "fabric_notebook" "notebook" {
  display_name              = var.display_name
  description               = var.description
  workspace_id              = var.workspace_id
  definition_update_enabled = true
  format                    = "ipynb"
  definition = {
    "notebook-content.ipynb"  = {
      source = var.local_file_path
    }
  }
}