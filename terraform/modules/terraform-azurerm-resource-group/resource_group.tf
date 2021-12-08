// Resource Group
resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_group
  name     = "${var.resource_group_prefix}${each.value.name}${var.resource_group_suffix}"
  location = each.value.location

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = []
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}