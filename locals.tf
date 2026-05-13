locals {
  capacities = { for c in var.fabric_capacities : c.basename => c }
  workspaces = var.workspaces
}

# Create a map of domain display_name to module id for lookup
locals {
  domain_ids = { for k, v in module.fabric_domain : k => v.id }
}

# Create a map of lakehouses with keys as "workspace_display_name:lakehouse_display_name"
locals {
  lakehouses = merge([
    for ws in local.workspaces : {
      for lh in try(ws.lakehouses, []) :
      "${ws.display_name}:${lh.display_name}" => {
        workspace_display_name = ws.display_name
        lakehouse              = lh
      }
    }
  ]...)
}