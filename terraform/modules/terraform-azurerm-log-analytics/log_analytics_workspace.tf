// Random string to use in Log analytics workspace name
resource "random_string" "workspace_name" {
  length  = 4
  special = false
  upper   = false
}


// Log analytics workspace
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = local.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days

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