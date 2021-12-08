// Private Route
resource "azurerm_route_table" "route_table" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.route_table_prefix}${var.name}${var.route_table_suffix}"

  # route = [
  #   for route in var.inline_route:
  #   {
  #   name                   = route.name
  #   address_prefix         = route.address_prefix
  #   next_hop_type          = route.next_hop_type
  #   next_hop_in_ip_address = route.next_hop_type == "VirtualAppliance" ? route.next_hop_in_ip_address : null
  # }
  # ]

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


// Route
resource "azurerm_route" "route" {
  for_each               = var.standalone_route
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  name                   = each.value.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null

  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = []
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}



