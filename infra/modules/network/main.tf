resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location           = var.location
  address_space      = var.address_space
}

# Create subnets
resource "azurerm_subnet" "subnets" {
  for_each = local.merged_subnet_config

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name = delegation.value.service
      }
    }
  }

  lifecycle {
    ignore_changes = [delegation]
  }
}

# Create NSGs only if enable_nsg is true
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.enable_nsg ? {
    for name, config in local.merged_subnet_config : name => config
  } : {}

  name                = "${each.value.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.merged_nsg_rules[each.key]
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_ranges          = security_rule.value.source_port_ranges
      destination_port_ranges     = security_rule.value.destination_port_ranges
      source_address_prefixes     = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      description                 = security_rule.value.description
    }
  }
}

# Associate NSGs with subnets only if enable_nsg is true
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = var.enable_nsg ? {
    for name, config in local.merged_subnet_config : name => config
  } : {}

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
} 