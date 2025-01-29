data "azurerm_client_config" "current" {}

resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  identity {
    type = "SystemAssigned"
  }

  network_rule_set {
    default_action = var.network_rule_set.default_action

    dynamic "ip_rule" {
      for_each = var.network_rule_set.ip_rules
      content {
        action   = "Allow"
        ip_range = ip_rule.value
      }
    }

    dynamic "virtual_network" {
      for_each = var.network_rule_set.subnet_ids
      content {
        action    = "Allow"
        subnet_id = virtual_network.value
      }
    }
  }

}

resource "azurerm_role_assignment" "acr_pull" {
  for_each = toset(var.acr_pull_principals)

  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = each.value
} 