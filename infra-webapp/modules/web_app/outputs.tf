output "id" {
  description = "ID of the web app"
  value       = azurerm_linux_web_app.main.id
}

output "name" {
  description = "Name of the web app"
  value       = azurerm_linux_web_app.main.name
}

output "default_hostname" {
  description = "Default hostname of the web app"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "custom_domain_verification_id" {
  description = "Custom domain verification ID"
  value       = azurerm_linux_web_app.main.custom_domain_verification_id
}

output "identity" {
  description = "Identity of the web app"
  value       = azurerm_linux_web_app.main.identity
}

output "outbound_ip_addresses" {
  description = "Outbound IP addresses of the web app"
  value       = azurerm_linux_web_app.main.outbound_ip_addresses
}

output "private_endpoint_url" {
  description = "Private endpoint URL of the web app"
  value       = one(azurerm_private_endpoint.main[*].custom_dns_configs[*].fqdn)
}

output "url" {
  description = "URL of the web app"
  value       = azurerm_linux_web_app.main.default_hostname
}
