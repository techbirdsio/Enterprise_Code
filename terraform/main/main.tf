// Resource Group
module "resource_group" {
  source         = "../modules/terraform-azurerm-resource-group"
  resource_group = var.resource_group

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


// Network Security Group and Rules
module "nsg" {
  source     = "../modules/terraform-azurerm-network-security-group"
  depends_on = [module.resource_group]
  for_each   = { for nsg in var.nsg_names : nsg => nsg }

  resource_group_name = module.resource_group.resource_group.network.name
  location            = module.resource_group.resource_group.network.location

  name = each.value #"public" #var.nsg_name

  nsg_rule      = each.value == "public" ? var.nsg_rule : {}
  security_rule = each.value == "public" ? var.security_rule : {}

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


// Route Table and Routes
module "route_table" {
  source     = "../modules/terraform-azurerm-route-table"
  depends_on = [module.resource_group]
  for_each   = var.route_table

  resource_group_name = module.resource_group.resource_group.network.name
  location            = module.resource_group.resource_group.network.location

  name                          = each.value.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  inline_route                  = var.inline_route
  standalone_route              = each.key == "private" ? var.standalone_route_private : var.standalone_route_public

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


// Virtual Network
module "vnet_hub" {
  source     = "../modules/terraform-azurerm-virtual-network"
  depends_on = [module.resource_group]

  resource_group_name = module.resource_group.resource_group.hub.name
  location            = module.resource_group.resource_group.hub.location

  vnet = var.vnet_hub

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


module "vnet_spoke" {
  source     = "../modules/terraform-azurerm-virtual-network"
  depends_on = [module.resource_group]

  resource_group_name = module.resource_group.resource_group.network.name
  location            = module.resource_group.resource_group.network.location

  vnet = var.vnet_spoke

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


// Subnet
module "subnet_spoke" {
  source     = "../modules/terraform-azurerm-subnet"
  depends_on = [module.resource_group, module.vnet_spoke, module.nsg, module.route_table]

  resource_group_name = module.resource_group.resource_group.network.name

  subnet_route_table_association                 = true
  network_security_group_association             = true
  enforce_private_link_endpoint_network_policies = true # Required to deploy private endpoint

  subnet = {
    jumpbox = {
      name                      = "aks-jumpbox"
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = ["10.1.0.0/24"]
      network_security_group_id = module.nsg["public"].nsg.id
      route_table_id            = module.route_table["public"].route_table.id
    },
    aks_spoke1 = {
      name                      = "aks-subnet"
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = ["10.1.1.0/24"]
      network_security_group_id = module.nsg["public"].nsg.id
      route_table_id            = module.route_table["public"].route_table.id
    },
    database_spoke1 = {
      name                      = "database"
      virtual_network_name      = module.vnet_spoke.vnet.spoke1.name
      address_prefixes          = ["10.1.2.0/24"]
      network_security_group_id = module.nsg["private"].nsg.id
      route_table_id            = module.route_table["private"].route_table.id
    }
  }

  service_endpoints = var.service_endpoints
}

// Log Analytics
module "log_analytics" {
  source              = "../modules/terraform-azurerm-log-analytics"
  resource_group_name = module.resource_group.resource_group.application.name
  location            = module.resource_group.resource_group.application.location
  name                = var.log_analytics_workspace_name
  solutions           = var.solutions
}


// AKS Cluster
module "aks" {
  source     = "../modules/terraform-azurerm-aks"
  depends_on = [module.subnet_spoke]

  resource_group_name = module.resource_group.resource_group.application.name
  location            = module.resource_group.resource_group.application.location

  name               = var.aks_name
  kubernetes_version = var.kubernetes_version
  dns_prefix         = var.aks_dns_prefix

  default_node_pool         = var.default_node_pool
  default_node_pool_scaling = var.default_node_pool_scaling

  network_profile = var.network_profile
  vnet_subnet_id  = module.subnet_spoke.subnet.aks_spoke1.id

  # Authentication and Authorization
  service_principal      = var.service_principal
  identity               = var.identity
  rbac_enabled           = var.rbac_enabled
  azure_active_directory = var.azure_active_directory
  linux_profile          = var.linux_profile

  # Add-on Profiles
  addon_profile_oms_agent = {
    enabled                    = true
    log_analytics_workspace_id = module.log_analytics.workspace.id
  }
  addon_profile_http_application_routing = var.addon_profile_http_application_routing

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}

// Application Gateway
module "application_gateway" {
  source = "../modules/terraform-azurerm-application-gateway"

  resource_group_name = module.resource_group.resource_group.network.name
  location            = module.resource_group.resource_group.network.location

  name  = "opengov-appgateway"
  zones = []

  # Subnet
  virtual_network_name = module.vnet_spoke.vnet.spoke1.name
  address_prefixes     = ["10.1.3.0/24"]

  autoscale_configurations = {
    min_capacity = 0
    max_capacity = 2
  }

  redirect_configurations = {}

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


// Azure Container Registry
module "acr" {
  source     = "../modules/terraform-azurerm-acr"
  depends_on = [module.resource_group, module.subnet_spoke]


  resource_group_name = module.resource_group.resource_group.data.name
  location            = module.resource_group.resource_group.data.location

  name                     = "opengovacr"
  georeplication_locations = ["westus"]
  #sku                      = "Standard" // Default = Premium

  #Network/Firewall Rules
  virtual_network = {
    vnet1 = {
      action    = "Allow"
      subnet_id = module.subnet_spoke.subnet.aks_spoke1.id
    }
  }

  ip_rule = {
    my1 = {
      action   = "Allow"
      ip_range = "49.35.7.237"
    }
  }

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}


module "spoke_baseline_private_endpoint_acr" {
  source = "../modules/terraform-azurerm-private-endpoint"

  resource_group_name = module.resource_group.resource_group.data.name
  location            = module.resource_group.resource_group.data.location

  # DNS Zone
  create_dns_zone         = true
  dns_zone_name           = "privatelink.azurecr.io"
  dns_zone_resource_group = module.resource_group.resource_group.network.name
  virtual_network_id      = module.vnet_spoke.vnet.spoke1.id

  name                           = module.acr.acr.name
  private_connection_resource_id = module.acr.acr.id
  subnet_id                      = module.subnet_spoke.subnet.aks_spoke1.id
  subresource_names              = ["registry"]

  resource_tags   = var.resource_tags
  deployment_tags = var.deployment_tags
}