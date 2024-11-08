locals {
  default_nsg_rules = {
    main = [
            {
        name                         = "allow_http_https_inbound"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["80", "443"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Allow HTTP/HTTPS inbound traffic"
      },
    ]
    frontend = [
      {
        name                         = "allow_http_https_inbound"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["80", "443"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Allow HTTP/HTTPS inbound traffic"
      },
      {
        name                         = "allow_health_probe_inbound"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["65200-65535"]
        source_address_prefixes      = ["AzureLoadBalancer"]
        destination_address_prefixes = ["*"]
        description                  = "Allow health probe from Azure Load Balancer"
      },
      {
        name                         = "deny_all_inbound"
        priority                     = 4096
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Deny all inbound traffic"
      }
    ]

    backend = [
      {
        name                         = "allow_api_inbound"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["3001"]
        source_address_prefixes      = ["10.0.1.0/24"]
        destination_address_prefixes = ["*"]
        description                  = "Allow API traffic from frontend subnet"
      },
      {
        name                         = "allow_health_probe_inbound"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["65200-65535"]
        source_address_prefixes      = ["AzureLoadBalancer"]
        destination_address_prefixes = ["*"]
        description                  = "Allow health probe from Azure Load Balancer"
      },
      {
        name                         = "allow_container_apps_control_plane"
        priority                     = 120
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["8443"]
        source_address_prefixes      = ["ContainerApps"]
        destination_address_prefixes = ["*"]
        description                  = "Allow Container Apps control plane communication"
      },
      {
        name                         = "deny_all_inbound"
        priority                     = 4096
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Deny all other inbound traffic"
      }
    ]

    webapp = [
      {
        name                         = "allow_health_probe_inbound"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["65200-65535"]
        source_address_prefixes      = ["AzureLoadBalancer"]
        destination_address_prefixes = ["*"]
        description                  = "Allow health probe from Azure Load Balancer"
      },
      {
        name                         = "deny_all_inbound"
        priority                     = 4096
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Deny all other inbound traffic"
      }
    ]

    database = [
      {
        name                         = "allow_postgresql_inbound"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["5432"]
        source_address_prefixes      = ["10.0.2.0/24"] # Backend subnet
        destination_address_prefixes = ["*"]
        description                  = "Allow PostgreSQL traffic from backend subnet"
      },
      {
        name                         = "allow_postgresql_management"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["5432"]
        source_address_prefixes      = ["AzureCloud"]
        destination_address_prefixes = ["*"]
        description                  = "Allow PostgreSQL management from Azure Cloud"
      },
      {
        name                         = "deny_all_inbound"
        priority                     = 4096
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Deny all other inbound traffic"
      }
    ]

    agw = [
      {
        name                         = "allow_gateway_manager"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["65200-65535"]
        source_address_prefixes      = ["GatewayManager"]
        destination_address_prefixes = ["*"]
        description                  = "Allow Gateway Manager"
      },
      {
        name                         = "allow_http_https_inbound"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["80", "443"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Allow HTTP/HTTPS inbound"
      },
      {
        name                         = "allow_health_probe_inbound"
        priority                     = 120
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["65200-65535"]
        source_address_prefixes      = ["AzureLoadBalancer"]
        destination_address_prefixes = ["*"]
        description                  = "Allow health probe from Azure Load Balancer"
      },
      {
        name                         = "allow_agw_v2_inbound"
        priority                     = 130
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["Internet"]
        destination_address_prefixes = ["*"]
        description                  = "Allow Application Gateway v2 inbound traffic"
      },
      {
        name                         = "deny_all_inbound"
        priority                     = 4096
        direction                    = "Inbound"
        access                       = "Deny"
        protocol                     = "*"
        source_port_ranges           = ["*"]
        destination_port_ranges      = ["*"]
        source_address_prefixes      = ["*"]
        destination_address_prefixes = ["*"]
        description                  = "Deny all other inbound traffic"
      }
    ]
  }

  # Merge default rules with any custom rules provided via variables, only if NSGs are enabled
  merged_nsg_rules = var.enable_nsg ? {
    for subnet_name, subnet_config in local.merged_subnet_config : subnet_name => lookup(local.default_nsg_rules, subnet_name, [])
  } : {}
} 