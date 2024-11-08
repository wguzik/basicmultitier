locals {
  subnet_config = {
    main = {
      name              = "main-subnet"
      address_prefixes  = ["10.0.0.0/24"]
      service_endpoints = ["Microsoft.KeyVault"]
      delegation        = null
    }
    frontend = {
      name              = "frontend-subnet"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Web"]
      delegation        = null
    }
    backend = {
      name              = "backend-subnet"
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Web"]
      delegation        = null
    }
    webapp = {
      name              = "webapp-subnet"
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Web"]
      delegation = {
        name    = "webapp"
        service = "Microsoft.Web/serverFarms"
      }
    }
    database = {
      name              = "database-subnet"
      address_prefixes  = ["10.0.4.0/24"]
      service_endpoints = ["Microsoft.Sql"]
      delegation = {
        name    = "fs"
        service = "Microsoft.DBforPostgreSQL/flexibleServers"
      }
    }
    agw = {
      name              = "agw-subnet"
      address_prefixes  = ["10.0.4.0/24"]
      service_endpoints = []
      delegation        = null
    }
  }

  # Merge subnet config with any custom address prefixes
  merged_subnet_config = {
    for name, config in local.subnet_config : name => merge(config,
      lookup(var.custom_subnet_prefixes, name, null) != null ? {
        address_prefixes = var.custom_subnet_prefixes[name]
      } : {}
    )
  }
} 