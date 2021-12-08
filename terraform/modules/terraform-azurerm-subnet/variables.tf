// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the subnet"
}

variable "subnet" {
  type = map(object({
    name                      = string       #(Required) The name of the subnet
    virtual_network_name      = string       #(Required) The name of the virtual network to which to attach the subnet
    address_prefixes          = list(string) #(Optional) The address prefixes to use for the subnet
    network_security_group_id = string       #(Optional) The ID of the Network Security Group which should be associated with the Subnet
    route_table_id            = string       #(Required) The ID of the Route Table which should be associated with the Subnet 
  }))
  description = "(Required) Arguments for subnet"
  default     = {}
}



// Optional Variables
variable "delegation" {
  type = map(object({
    name = string #(Required) A name for this delegation.
    service_delegation = object({
      name    = string       # (Required) The name of service to delegate to
      actions = list(string) #(Optional) A list of Actions which should be delegated
    })
  }))
  description = "(Optional) One or more delegation blocks"
  default     = {}
}

variable "service_endpoints" {
  type        = list(string)
  description = "(Optional) The list of Service endpoints to associate with the subnet"
  default     = []
}

# Private Link
variable "enforce_private_link_endpoint_network_policies" {
  type        = bool
  description = "(Optional) Enable or Disable network policies for the private link endpoint on the subnet"
  default     = false
}
variable "enforce_private_link_service_network_policies" {
  type        = bool
  description = "(Optional) Enable or Disable network policies for the private link service on the subnet"
  default     = false
}

variable "subnet_route_table_association" {
  type        = bool
  description = "(Optional) Accociate on Not the Subnet to Route Table. Route table id must be passed if set to True"
  default     = false
}

variable "network_security_group_association" {
  type        = bool
  description = "(Optional) Accociate on Not the NSG to Subnet. NSG id must be passed if set to True"
  default     = false
}

variable "subnet_prefix" {
  type        = string
  description = "(Required) Prefix for the subnet name"
  default     = ""
}

variable "subnet_suffix" {
  type        = string
  description = "(Optional) Suffix for the subnet name"
  default     = ""
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for the resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Additional Tags for the deployment"
  default     = {}
}

variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}

variable "timeout" {
  type        = string
  description = "(Optional) Timeout"
  default     = "30m"
}


// Local Values
locals {
  timeout_duration = var.timeout
}

