locals {
  postgresql_admin_username = "merito"
}

# Generate random password for PostgreSQL
resource "random_password" "postgresql" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store PostgreSQL password in Key Vault
resource "azurerm_key_vault_secret" "postgresql_username" {
  name         = "postgresql-username"
  value        = local.postgresql_admin_username
  key_vault_id = module.key_vault.id
}

# Store PostgreSQL password in Key Vault
resource "azurerm_key_vault_secret" "postgresql_password" {
  name         = "postgresql-password"
  value        = random_password.postgresql.result
  key_vault_id = module.key_vault.id
}
