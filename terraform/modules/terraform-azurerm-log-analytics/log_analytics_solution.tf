// Log analytics solution
resource "azurerm_log_analytics_solution" "solution" {
  for_each              = var.solutions
  solution_name         = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = coalesce(var.workspace_resource_id, azurerm_log_analytics_workspace.workspace.id)
  workspace_name        = coalesce(var.workspace_name, azurerm_log_analytics_workspace.workspace.name)

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}