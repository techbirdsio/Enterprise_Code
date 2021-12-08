// Private Subnet
resource "azurerm_subnet" "subnet" {
  for_each                                       = var.subnet
  resource_group_name                            = var.resource_group_name
  name                                           = "${var.subnet_prefix}${each.value.name}${var.subnet_suffix}"
  virtual_network_name                           = each.value.virtual_network_name
  address_prefixes                               = each.value.address_prefixes
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = var.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = var.enforce_private_link_service_network_policies

  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = []
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}


// Route table association
resource "azurerm_subnet_route_table_association" "route_table_association" {
  for_each       = var.subnet_route_table_association ? var.subnet : {}
  subnet_id      = each.value.route_table_id != "null" ? azurerm_subnet.subnet[each.key].id : null
  route_table_id = each.value.route_table_id

  depends_on = [
    azurerm_subnet.subnet,
    var.it_depends_on,
  ]

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}


// Network Security Group association
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each                  = var.network_security_group_association ? var.subnet : {}
  subnet_id                 = each.value.network_security_group_id != "null" ? azurerm_subnet.subnet[each.key].id : null
  network_security_group_id = each.value.network_security_group_id

  depends_on = [
    azurerm_subnet.subnet,
    var.it_depends_on
  ]

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}

