// Creates a private dns zone
resource "azurerm_private_dns_zone" "dns_zone" {
  count               = var.create_dns_zone ? 1 : 0
  name                = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
  tags                = merge(var.resource_tags, var.deployment_tags)
}


// Links the private dns zone to Vnet
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  count                 = var.create_dns_zone ? 1 : 0
  name                  = local.private_dns_zone_name
  resource_group_name   = var.dns_zone_resource_group
  private_dns_zone_name = local.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  tags                  = merge(var.resource_tags, var.deployment_tags)
}


// Private Endpoint
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = local.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = local.private_endpoint_name
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
    request_message                = var.request_message
    private_ip_address             = var.private_ip_address
  }

  dynamic "private_dns_zone_group" {
    for_each = var.create_dns_zone ? [1] : []
    content {
      name                 = local.private_dns_zone_name
      private_dns_zone_ids = [local.private_dns_zone_id]
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
