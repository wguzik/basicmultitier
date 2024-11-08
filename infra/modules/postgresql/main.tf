resource "azurerm_postgresql_flexible_server" "server" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.admin_username
  administrator_password = var.admin_password

  sku_name = "B_Standard_B1ms"
  version  = "15"

  zone = "2"

  public_network_access_enabled = false

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "fw_rules" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_postgresql_flexible_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.server.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}
