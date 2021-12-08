// Resource Group
/* output "resource_group" {
  value = module.resource_group.resource_group
} */

/* // Network Security Group
output "nsg" {
  value = module.nsg
} */

/* // Route Table
output "route_table" {
  value = module.route_table
}

// Public IP Address
output "public_ip" {
  value = module.public_ip
}


// Virtual Network
output "vnet_hub" {
  value = module.vnet_hub
}

output "vnet_spoke" {
  value = module.vnet_spoke
} */

// Subnet
#output "subnet_hub" {
#  value = module.subnet_hub
#}

/* output "subnet_spoke" {
  value = module.subnet_spoke
} */

/* // Network Interface
output "nic" {
  value = module.nic
} */


// AKS
/* output "aks" {
  value = module.aks
} */


/* // Virtual Mahchine
output "linux_vm" {
  value = module.linux_vm.linux_vm[0].private_ip_addresses
} */

// Database
/*
output "cosmosdb" {
  value = module.cosmosdb.cosmosdb.endpoint
}


output "postgresql_server" {
  value = module.postgresql.postgresql_server
}

output "postgresql_server_replica" {
  value = module.postgresql.postgresql_server_replica
}
*/

/* output "private_endpoint" {
  value = module.private_endpoint.private_endpoint
} */