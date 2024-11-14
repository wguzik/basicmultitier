module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags = {
    environment = var.environment
    project     = var.project_name
    owner       = var.owner
  }
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = local.vnet_name
  address_space       = ["10.0.0.0/16"]

  custom_subnet_prefixes = {
    frontend = ["10.0.1.0/24"]
    backend  = ["10.0.2.0/26"]
    database = ["10.0.2.128/27"]
  }

  # enable_nsg = true does not work yet
}
module "dnszone" {
  source              = "./modules/dnszone"
  resource_group_name = module.resource_group.name
  vnet_id             = module.network.vnet_id
}

module "key_vault" {
  source              = "./modules/key_vault"
  name                = local.key_vault_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  #allowed_ips = [
  #  var.my_ip
  #]

  enable_private_endpoint    = true
  private_endpoint_subnet_id = module.network.subnet_ids["main"]
  private_dns_zone_id        = module.dnszone.keyvault_dns_zone_id
}

module "postgresql" {
  source              = "./modules/postgresql"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  server_name         = local.postgresql_server_name
  admin_username      = local.postgresql_admin_username
  admin_password      = random_password.postgresql.result
  database_name       = local.postgresql_db_name

  key_vault_id = module.key_vault.id

  subnet_id           = module.network.subnet_ids["database"]
  private_dns_zone_id = module.dnszone.psql_dns_zone_id
}

module "backend" {
  source              = "./modules/web_app"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  name                = local.backend_app_name
  docker_image_name   = var.docker_backend_image
  docker_registry_url = var.docker_registry_url
  subnet_id           = module.network.subnet_ids["webapp"]

  enable_private_endpoint    = false # zmien tutaj
  private_endpoint_subnet_id = module.network.subnet_ids["backend"]
  private_dns_zone_id        = module.dnszone.webapp_dns_zone_id
  app_settings = {
    "WEBSITES_PORT"     = "3001"
    "DATABASE_URL" = module.postgresql.connection_string
  }

  depends_on = [ module.postgresql ]
}

module "frontend" {
  source              = "./modules/web_app"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  name                = local.frontend_app_name
  docker_image_name   = var.docker_frontend_image
  docker_registry_url = var.docker_registry_url
  subnet_id           = module.network.subnet_ids["webapp"]

  enable_private_endpoint    = false
  private_endpoint_subnet_id = module.network.subnet_ids["frontend"]
  private_dns_zone_id        = module.dnszone.webapp_dns_zone_id
  app_settings = {
    "WEBSITES_PORT" = "3000"
    "REACT_APP_API_URL"=module.backend.url
  }
}

## nie jest potrzebne do labu
#module "container_registry" {
#  source              = "./modules/container_registry"
#  name                = var.acr_name
#  resource_group_name = module.resource_group.name
#  location           = module.resource_group.location
#  sku                = "Premium"
#  
#  network_rule_set = {
#    default_action = "Deny"
#    ip_rules       = var.allowed_ip_ranges
#    subnet_ids     = [
#      module.network.subnet_ids["frontend"],
#      module.network.subnet_ids["backend"]
#    ]
#  }
#
#  # Grant pull access to web app and container app
#  acr_pull_principals = [
#    module.frontend.identity.principal_id,
#    module.backend.identity.principal_id
#  ]
#
#  enable_private_endpoint = true
#  private_endpoint_subnet_id = module.network.subnet_ids["backend"]
#  private_dns_zone_ids   = [azurerm_private_dns_zone.acr.id]
#
#  tags = var.tags
#}

