# Tests that the fabric_lakehouse module correctly plans a lakehouse resource.
# Covers both schema modes since enable_schemas changes the lakehouse behaviour
# at the API level (schemas cannot be disabled once enabled).
mock_provider "fabric" {}

# Verifies display_name, workspace_id, and that schemas are disabled by default.
run "lakehouse_without_schemas" {
  command = plan

  variables {
    display_name   = "Raw Data"
    description    = "Raw data lakehouse"
    workspace_id   = "00000000-0000-0000-0000-000000000001"
    enable_schemas = false
  }

  assert {
    condition     = fabric_lakehouse.lakehouse.display_name == "Raw Data"
    error_message = "Lakehouse display name should match input"
  }

  assert {
    condition     = fabric_lakehouse.lakehouse.workspace_id == "00000000-0000-0000-0000-000000000001"
    error_message = "Lakehouse workspace ID should match input"
  }

  assert {
    condition     = fabric_lakehouse.lakehouse.configuration.enable_schemas == false
    error_message = "Schemas should be disabled"
  }
}

# Verifies that enable_schemas = true is passed through to the resource configuration.
run "lakehouse_with_schemas" {
  command = plan

  variables {
    display_name   = "Curated Data"
    description    = ""
    workspace_id   = "00000000-0000-0000-0000-000000000002"
    enable_schemas = true
  }

  assert {
    condition     = fabric_lakehouse.lakehouse.configuration.enable_schemas == true
    error_message = "Schemas should be enabled"
  }
}
