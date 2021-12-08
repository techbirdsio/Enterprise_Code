// Virtual Network
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vnet
  name                = "${var.vnet_prefix}${each.value.name}${var.vnet_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = each.value.address_space
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan

    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}