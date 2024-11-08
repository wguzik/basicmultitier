output "id" {
  description = "ID of the application gateway"
  value       = azurerm_application_gateway.main.id
}

output "name" {
  description = "Name of the application gateway"
  value       = azurerm_application_gateway.main.name
}

output "public_ip_address" {
  description = "Public IP address of the application gateway"
  value       = azurerm_public_ip.agw.ip_address
}

output "backend_address_pool_id" {
  description = "ID of the backend address pool"
  value       = one(azurerm_application_gateway.main.backend_address_pool).id
}

output "frontend_ip_configuration" {
  description = "Frontend IP configuration of the application gateway"
  value       = one(azurerm_application_gateway.main.frontend_ip_configuration)
}

output "http_listener_id" {
  description = "ID of the HTTP listener"
  value       = one(azurerm_application_gateway.main.http_listener).id
} 