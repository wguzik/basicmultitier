output "id" {
  description = "The ID of the container registry"
  value       = azurerm_container_registry.acr.id
}

output "name" {
  description = "The name of the container registry"
  value       = azurerm_container_registry.acr.name
}

output "login_server" {
  description = "The login server URL for the registry"
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The admin username for the registry"
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_username : null
  sensitive   = true
}

output "admin_password" {
  description = "The admin password for the registry"
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_password : null
  sensitive   = true
}

output "identity" {
  description = "The identity of the container registry"
  value       = azurerm_container_registry.acr.identity
} 