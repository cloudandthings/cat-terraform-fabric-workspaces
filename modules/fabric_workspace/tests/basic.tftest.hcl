# Tests that the fabric_workspace module correctly plans a Fabric workspace and its
# optional domain assignment. The fabric_capacity data source is mocked with state
# "Active" to satisfy the postcondition that guards against inactive capacities.
#
# Two cases are covered:
#   1. With a domain ID -> domain assignment resource is created
#   2. Without a domain ID (empty string) -> domain assignment is skipped entirely
mock_provider "fabric" {
  mock_data "fabric_capacity" {
    defaults = {
      id    = "00000000-0000-0000-0000-000000000001"
      state = "Active"
    }
  }
}

# Verifies that the workspace is planned with the correct display name and description,
# and that a domain assignment is created referencing the provided domain ID.
run "workspace_planned_with_domain" {
  command = plan

  variables {
    display_name     = "Dev Workspace"
    description      = "Development workspace"
    capacity_id      = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Fabric/capacities/test-capacity"
    fabric_domain_id = "00000000-0000-0000-0000-000000000002"
  }

  assert {
    condition     = fabric_workspace.workspace.display_name == "Dev Workspace"
    error_message = "Workspace display name should match input"
  }

  assert {
    condition     = fabric_workspace.workspace.description == "Development workspace"
    error_message = "Workspace description should match input"
  }

  assert {
    condition     = fabric_domain_workspace_assignments.domain_assignment[0].domain_id == "00000000-0000-0000-0000-000000000002"
    error_message = "Domain assignment should reference the provided domain ID"
  }
}

# Verifies that no domain assignment resource is planned when fabric_domain_id is
# empty, confirming the count = 0 conditional in main.tf works correctly.
run "workspace_planned_without_domain" {
  command = plan

  variables {
    display_name     = "Dev Workspace"
    description      = ""
    capacity_id      = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Fabric/capacities/test-capacity"
    fabric_domain_id = ""
  }

  assert {
    condition     = fabric_workspace.workspace.display_name == "Dev Workspace"
    error_message = "Workspace display name should match input"
  }

  assert {
    condition     = length(fabric_domain_workspace_assignments.domain_assignment) == 0
    error_message = "No domain assignment should be created when fabric_domain_id is empty"
  }
}
