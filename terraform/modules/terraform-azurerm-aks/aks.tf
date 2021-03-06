// AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = local.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Use merge maps & Locals to reduce inputs
  role_based_access_control {
    enabled = var.rbac_enabled
    dynamic "azure_active_directory" {
      for_each = var.azure_active_directory
      content {
        managed                = azure_active_directory.value.managed
        admin_group_object_ids = azure_active_directory.value.admin_group_object_ids
        client_app_id          = azure_active_directory.value.client_app_id
        server_app_id          = azure_active_directory.value.server_app_id
        server_app_secret      = azure_active_directory.value.server_app_secret
        tenant_id              = azure_active_directory.value.tenant_id
      }
    }
  }
  /*  dynamic "role_based_access_control" {
    for_each = var.role_based_access_control
    content {
      enabled = role_based_access_control.value.enabled
      azure_active_directory {
        managed                = role_based_access_control.value.azure_active_directory.managed
        admin_group_object_ids = role_based_access_control.value.azure_active_directory.admin_group_object_ids
        client_app_id          = role_based_access_control.value.azure_active_directory.client_app_id
        server_app_id          = role_based_access_control.value.azure_active_directory.server_app_id
        server_app_secret      = role_based_access_control.value.azure_active_directory.server_app_secret
        tenant_id              = role_based_access_control.value.azure_active_directory.tenant_id
      }
    }
  } */


  default_node_pool {
    name                  = var.default_node_pool.name
    vm_size               = var.default_node_pool.vm_size
    availability_zones    = var.default_node_pool.availability_zones
    enable_auto_scaling   = var.default_node_pool_scaling.enable_auto_scaling
    enable_node_public_ip = var.default_node_pool.enable_node_public_ip
    max_pods              = var.default_node_pool.max_pods
    node_labels           = var.default_node_pool.node_labels
    node_taints           = var.default_node_pool.node_taints
    os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
    type                  = var.default_node_pool.type
    vnet_subnet_id        = var.vnet_subnet_id
    node_count            = var.default_node_pool.node_count
    orchestrator_version  = var.default_node_pool.orchestrator_version
    tags                  = var.default_node_pool.tags

    min_count = var.default_node_pool_scaling.enable_auto_scaling ? var.default_node_pool_scaling.min_count : null
    max_count = var.default_node_pool_scaling.enable_auto_scaling ? var.default_node_pool_scaling.max_count : null
  }

  dynamic "network_profile" {
    for_each = var.network_profile
    content {
      network_plugin     = network_profile.value.network_plugin
      network_policy     = network_profile.value.network_policy
      dns_service_ip     = network_profile.value.dns_service_ip
      docker_bridge_cidr = network_profile.value.docker_bridge_cidr
      pod_cidr           = network_profile.value.pod_cidr
      service_cidr       = network_profile.value.service_cidr
      outbound_type      = network_profile.value.outbound_type
      load_balancer_sku  = network_profile.value.load_balancer_sku
    }
  }

  dynamic "linux_profile" {
    for_each = var.linux_profile
    content {
      admin_username = linux_profile.value.admin_username
      ssh_key {
        key_data = linux_profile.value.ssh_key.key_data
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type = each.value.type
    }
  }

  dynamic "service_principal" {
    for_each = var.service_principal
    content {
      client_id     = service_principal.value.client_id
      client_secret = service_principal.value.client_secret
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.addon_profile_oms_agent.enabled
      log_analytics_workspace_id = var.addon_profile_oms_agent.log_analytics_workspace_id
    }
    kube_dashboard {
      enabled = var.addon_profile_kube_dashboard.enabled
    }
    http_application_routing {
      enabled = var.addon_profile_http_application_routing.enabled
    }
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      #addon_profile[0].kube_dashboard,
      default_node_pool[0].node_count,
      default_node_pool[0].max_count,
      default_node_pool[0].min_count,
      default_node_pool[0].tags,
      tags,
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}
//**********************************************************************************************


