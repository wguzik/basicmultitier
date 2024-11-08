output "keyvault_dns_zone_id" {
  description = "The ID of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.id
}

output "keyvault_dns_zone_name" {
  description = "The name of the Key Vault private DNS zone"
  value       = azurerm_private_dns_zone.keyvault.name
}

output "webapp_dns_zone_id" {
  description = "The ID of the Web App private DNS zone"
  value       = azurerm_private_dns_zone.webapp.id
}

output "webapp_dns_zone_name" {
  description = "The name of the Web App private DNS zone"
  value       = azurerm_private_dns_zone.webapp.name
}

output "psql_dns_zone_id" {
  description = "The ID of the PostgreSQL private DNS zone"
  value       = azurerm_private_dns_zone.psql.id
}

output "psql_dns_zone_name" {
  description = "The name of the PostgreSQL private DNS zone"
  value       = azurerm_private_dns_zone.psql.name
} 