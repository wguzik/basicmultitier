output "server_id" {
  description = "ID of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.server.id
}

output "server_name" {
  description = "Name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.server.name
}

output "server_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.server.fqdn
}

#questionable technique
output "connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${var.admin_username}@${azurerm_postgresql_flexible_server.server.name}:${var.admin_password}@${azurerm_postgresql_flexible_server.server.fqdn}:5432"
  sensitive   = true
}
