locals {
  # Location mapping to short codes
  location_map = {
    westeurope     = "we"
    northeurope    = "ne"
    eastus         = "eu"
    westus         = "wu"
    eastus2        = "eu2"
    westus2        = "wu2"
    centralus      = "cu"
    southcentralus = "scu"
  }

  # Get location short code, default to "we" if not found
  location_short = lookup(local.location_map, var.location, "we")

  # Base name format: {project}-{env}-{location}
  name_prefix = "${var.project_name}-${var.environment}-${local.location_short}"

  # Resource naming
  resource_group_name    = "${local.name_prefix}-rg"
  vnet_name              = "${local.name_prefix}-vnet"
  postgresql_server_name = "${local.name_prefix}-psql"
  postgresql_db_name     = "${local.name_prefix}-db"
  frontend_app_name      = "${local.name_prefix}-fe"
  backend_app_name       = "${local.name_prefix}-be"
  appgw_name             = "${local.name_prefix}-agw"
  key_vault_name         = "${local.name_prefix}-kv"
  acr_name               = replace("${var.project_name}${var.environment}acr", "-", "") # ACR name cannot contain hyphens
} 