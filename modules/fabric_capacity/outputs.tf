output "id" {
  description = "The ID of the Fabric capacity"
  value       = azurerm_fabric_capacity.this.id
}

output "automation_account_id" {
  description = "The ID of the Azure Automation Account managing this capacity's schedules. Null when scheduler is disabled."
  value       = var.scheduler != null ? azurerm_automation_account.this[0].id : null
}