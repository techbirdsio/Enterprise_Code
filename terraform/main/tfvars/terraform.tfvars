// Tags
//**********************************************************************************************
resource_tags = {
  terraform = "1.0.1"
  owner     = "Satyam"
}

deployment_tags = {
  environment = "Dev"
}
//**********************************************************************************************


// Resource Group
//**********************************************************************************************
resource_group = {
  hub = {
    name     = "cloudmatos-Hub"
    location = "eastus"
  },
  network = {
    name     = "cloudmatos-network"
    location = "eastus"
  },
  data = {
    name     = "cloudmatos-data"
    location = "eastus"
  },
  monitor = {
    name     = "cloudmatos-monitor"
    location = "eastus"
  },
  application = {
    name     = "cloudmatos-app"
    location = "eastus"
  },
  #security = {
  #  name     = "opengov-security"
  #  location = "eastus"
  #},
}
//**********************************************************************************************


// Network Security Group
//**********************************************************************************************
nsg_names = ["private", "public"]
#nsg_name      = "vm"
security_rule = {}
#nsg_rule = {}

# NSG rules for SSH,HTTP(s) and RDP
nsg_rule = {
  ssh = {
    name                                       = "ssh"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["22"]
    source_address_prefix                      = "0.0.0.0/0"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Enable SSH traffic for Linux"
  },
  rdp = {
    name                                       = "rdp"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["3389"]
    source_address_prefix                      = "0.0.0.0/0"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Enable RDP traffic for Windows"
  },
  http_https = {
    name                                       = "http_https"
    priority                                   = 120
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["80", "443"]
    source_address_prefix                      = "0.0.0.0/0"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Enable HTTP and HTTPS traffic"
  }
}

# NSG rules for Application Gateway
/* nsg_rule = {
  GatewayManager = {
    name                                       = "GatewayManager"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["65200-65535"]
    source_address_prefix                      = "GatewayManager"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Azure infrastructure communication"
  },
  AzureLoadBalancer = {
    name                                       = "AzureLoadBalancer"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["0-65535"]
    source_address_prefix                      = "AzureLoadBalancer"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Azure Load Balancer"
  },
  allow_http = {
    name                                       = "AllowHTTP"
    priority                                   = 120
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["80"]
    source_address_prefix                      = "0.0.0.0/0"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "HTTP access from anywhere"
  },
  DenyInternet = {
    name                                       = "DenyInternet"
    priority                                   = 130
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["0-65535"]
    source_address_prefix                      = "Internet"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Deny Internet raffic"
  },
  VirtualNetwork = {
    name                                       = "VirtualNetwork"
    priority                                   = 140
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "tcp"
    source_port_range                          = "*"
    source_port_ranges                         = null
    destination_port_range                     = null
    destination_port_ranges                    = ["0-65535"]
    source_address_prefix                      = "VirtualNetwork"
    source_address_prefixes                    = null
    destination_address_prefix                 = "*"
    destination_address_prefixes               = null
    source_application_security_group_ids      = null
    destination_application_security_group_ids = null
    description                                = "Unblcok access to Private IP address"
  }
} */
//**********************************************************************************************


// Route Table
//**********************************************************************************************
route_table = {
  private = {
    name                          = "route-table-private"
    disable_bgp_route_propagation = false
  },
  public = {
    name                          = "route-table-public"
    disable_bgp_route_propagation = false
  }
}
standalone_route_private = {
  standalone = {
    name                   = "standalone"
    address_prefix         = "10.1.0.0/16"
    next_hop_type          = "VnetLocal"
    next_hop_in_ip_address = null
  }
}
standalone_route_public = {}

/* public1 = {
  name                   = "public1"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "Internet"
  next_hop_in_ip_address = null
} */

#inline_route = [
#  {
# name                   = "inline1"
# address_prefix         = "10.0.1.0/24"
# next_hop_type          = "VnetLocal"
# next_hop_in_ip_address = null
#   }
#  ]
//**********************************************************************************************


// Public IP Address
//**********************************************************************************************
public_ip = {
  standard = {
    name              = "aks-jumpbox"
    sku               = "Standard"
    allocation_method = "Static"
  },
  /*  basic = {
    name              = "pip-basic"
    sku               = "Basic"
    allocation_method = "Static"
  } */
}
//**********************************************************************************************


// Virtual Network
//**********************************************************************************************
# Hub Vnet
#vnet_hub_count = 1
vnet_hub = {
  hub = {
    name          = "vnet-hub"
    address_space = ["10.0.0.0/24"]
  }
}

# Spoke Vnet
#vnet_spoke_count = 1
vnet_spoke = {
  spoke1 = {
    name          = "vnet-spoke1"
    address_space = ["10.1.0.0/16"]
  },
  /* spoke2 = {
    name          = "vnet-spoke2"
    address_space = ["10.0.2.0/24"]
  } */
}
//**********************************************************************************************


// Subnet
//**********************************************************************************************
service_endpoints = ["Microsoft.Sql", "Microsoft.ContainerRegistry"]
/* subnet = {
    private-1 = {
      name                      = "private-1"
      virtual_network_name      = 
      address_prefixes          = ["10.0.0.0/26"]
      network_security_group_id = 
      route_table_id            = 
    },
    private-2 = {
      name                      = "private-2"
      virtual_network_name      = 
      address_prefixes          = ["10.0.0.64/26"]
      network_security_group_id = 
      route_table_id            =
    },
    public-1 = {
      name                      = "public-1"
      virtual_network_name      = 
      address_prefixes          = ["10.0.0.128/26"]
      network_security_group_id = 
      route_table_id            = 
    },
    public-2 = {
      name                      = "public-2"
      virtual_network_name      = 
      address_prefixes          = ["10.0.0.192/26"]
      network_security_group_id = 
      route_table_id            =
    }
  } */
//**********************************************************************************************


// Network Interface
//**********************************************************************************************
nic_names = ["public"]
#nic_names = ["private", "public"]
#nic_public  = "vm-public"
#nic_private = "vm-private"
ip_configuration = {
  ipconf1 = {
    name                          = "ipconf1"
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    private_ip_address            = null
    public_ip_address_id          = null
    subnet_id                     = null
    primary                       = null
  }
}
//**********************************************************************************************


// Log Analytics
//**********************************************************************************************
log_analytics_workspace_name = "log-workspace-test"
solutions = {
  AzureNSGAnalytics = {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureNSGAnalytics"
  }
}
//**********************************************************************************************

// AKS
//**********************************************************************************************
aks_name           = "opengov-aks"
kubernetes_version = "1.18.10"
aks_dns_prefix     = "tfaks"
default_node_pool = {
  name                  = "nodepool"
  vm_size               = "Standard_DS2_v2"
  availability_zones    = []
  enable_node_public_ip = false
  max_pods              = null
  node_labels           = null #{}
  node_taints           = null #[]
  os_disk_size_gb       = null
  type                  = "VirtualMachineScaleSets"
  vnet_subnet_id        = null
  node_count            = 3
  orchestrator_version  = null
  tags                  = null #{} 
}

default_node_pool_scaling = {
  enable_auto_scaling = true
  min_count           = 3
  max_count           = 6
}

network_profile = {
  profile1 = {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = null
    docker_bridge_cidr = null
    pod_cidr           = null
    service_cidr       = null
    outbound_type      = null
    load_balancer_sku  = null
  }
}


rbac_enabled           = true
azure_active_directory = {}
#azure_active_directory = {
#  rbac_aad = {
#    managed                = true
#    admin_group_object_ids = ["33bc8137-4465-47c4-a7f6-fc405771c441"]
#    client_app_id          = null
#    server_app_id          = null
#    server_app_secret      = null
#    tenant_id              = null
#  }
#}
#identity = {}

# Addon Profiles
addon_profile_http_application_routing = {
  enabled = true
}


//**********************************************************************************************


// Virtual Machine
//**********************************************************************************************
#vm_names = ["webserver", "dbserver"]
jumpbox_names = ["aks-jumpbox"]

source_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "latest"
}

os_disk = {
  caching                   = "ReadWrite"
  storage_account_type      = "Standard_LRS"
  disk_size_gb              = 30
  disk_encryption_set_id    = null
  name                      = null
  write_accelerator_enabled = null
}
//**********************************************************************************************


allowed_cidrs = {
  public = "0.0.0.0/0"
}