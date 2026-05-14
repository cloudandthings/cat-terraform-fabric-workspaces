# Tests that when a scheduler is configured, all automation infrastructure is planned:
# automation account (with public network access disabled), runbook, pause/resume
# schedules, job schedules linking the runbook to those schedules, and a Contributor
# role assignment so the automation account can pause/resume the capacity.
mock_provider "azurerm" {}
mock_provider "azuread" {}
mock_provider "time" {}

# Uses a weekday-only pause/resume schedule (Mon-Fri) at 20:00 / 07:00 UTC.
run "with_scheduler_creates_all_resources" {
  command = plan

  variables {
    basename     = "testcapacity"
    location     = "North Europe"
    sku          = "F4"
    admin_emails = ["admin@example.com"]
    scheduler = {
      pause_time  = "20:00"
      resume_time = "07:00"
      pause_days  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      resume_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
  }

  assert {
    condition     = length(azurerm_automation_account.this) == 1
    error_message = "Automation account should be created when scheduler is set"
  }

  assert {
    condition     = azurerm_automation_account.this[0].name == "testcapacity-automation"
    error_message = "Automation account name should be <basename>-automation"
  }

  assert {
    condition     = azurerm_automation_account.this[0].public_network_access_enabled == false
    error_message = "Automation account should have public network access disabled"
  }

  assert {
    condition     = length(azurerm_automation_runbook.manage_capacity) == 1
    error_message = "Runbook should be created when scheduler is set"
  }

  assert {
    condition     = azurerm_automation_runbook.manage_capacity[0].runbook_type == "PowerShell72"
    error_message = "Runbook type should be PowerShell72"
  }

  assert {
    condition     = length(azurerm_automation_schedule.pause_schedule) == 1
    error_message = "Pause schedule should be created when scheduler is set"
  }

  assert {
    condition     = length(azurerm_automation_schedule.resume_schedule) == 1
    error_message = "Resume schedule should be created when scheduler is set"
  }

  assert {
    condition     = length(azurerm_automation_job_schedule.pause_schedule) == 1
    error_message = "Pause job schedule should be created when scheduler is set"
  }

  assert {
    condition     = length(azurerm_automation_job_schedule.resume_schedule) == 1
    error_message = "Resume job schedule should be created when scheduler is set"
  }

  assert {
    condition     = length(azurerm_role_assignment.automation_contributor) == 1
    error_message = "Role assignment should be created when scheduler is set"
  }
}
