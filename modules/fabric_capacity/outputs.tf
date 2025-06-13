output "id" {
  description = "The ID of the Fabric capacity"
  value       = azurerm_fabric_capacity.this.id
}

# Add this output to debug
output "debug_admin_object_id" {
  value = data.azuread_user.admin.object_id
}

output "debug_admin_email" {
  value = var.admin_email
}