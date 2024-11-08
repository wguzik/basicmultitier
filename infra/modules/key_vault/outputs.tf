output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "private_endpoint_ip" {
  description = "The private IP address of the Key Vault private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.keyvault[0].private_service_connection[0].private_ip_address : null
}

output "private_endpoint_id" {
  description = "The ID of the Key Vault private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.keyvault[0].id : null
}
