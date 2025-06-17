data "fabric_capacity" "capacity" {
  display_name = split("/", var.capacity_id)[8]  # Extract capacity name from resource ID
  
  lifecycle {
    postcondition {
      condition     = self.state == "Active"
      error_message = "Fabric Capacity is not in Active state. Please check the Fabric Capacity status."
    }
  }
}

resource "fabric_workspace" "workspace" {
    display_name = var.display_name
    description  = var.description
    capacity_id  = data.fabric_capacity.capacity.id
}

resource "fabric_domain_workspace_assignments" "domain_assignment" {
    domain_id    = var.fabric_domain_id
    workspace_ids = [
        fabric_workspace.workspace.id
    ]
}