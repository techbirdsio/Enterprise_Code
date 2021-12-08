// Required Variables
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the network security group"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the network security group"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists"
}


// Optional Variables
# Network security group inline rules
variable "security_rule" {
  type = map(object({
    name                                       = string       #(Required) The name of the security rule
    priority                                   = number       #(Required) Specifies the priority of the rule. The value can be between 100 and 4096
    direction                                  = string       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic
    access                                     = string       #(Required) Specifies whether network traffic is allowed or denied
    protocol                                   = string       #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all
    source_port_range                          = string       #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any
    source_port_ranges                         = list(string) #(Optional) List of source ports or port ranges
    destination_port_range                     = string       #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any
    destination_port_ranges                    = list(string) #(Optional) List of destination ports or port ranges
    source_address_prefix                      = string       #(Optional) CIDR or source IP range or * to match any IP
    source_address_prefixes                    = list(string) #(Optional) List of source address prefixes. Tags may not be used
    destination_address_prefix                 = string       #(Optional) CIDR or destination IP range or * to match any IP
    destination_address_prefixes               = list(string) #(Optional) List of destination address prefixes
    source_application_security_group_ids      = list(string) #(Optional) A List of source Application Security Group ID's
    destination_application_security_group_ids = list(string) #(Optional) A List of destination Application Security Group ID's
    description                                = string       #(Optional) A description for this rule. Restricted to 140 characters
  }))
  description = "(Optional) List of objects representing security rules"
  default     = {}
}

# NSG rule resource
variable "nsg_rule" {
  type = map(object({
    name                                       = string       #(Required) The name of the security rule
    priority                                   = number       #(Required) Specifies the priority of the rule. The value can be between 100 and 4096
    direction                                  = string       #(Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic
    access                                     = string       #(Required) Specifies whether network traffic is allowed or denied
    protocol                                   = string       #(Required) Network protocol this rule applies to. Can be Tcp, Udp, Icmp, or * to match all
    source_port_range                          = string       #(Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any
    source_port_ranges                         = list(string) #(Optional) List of source ports or port ranges
    destination_port_range                     = string       #(Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any
    destination_port_ranges                    = list(string) #(Optional) List of destination ports or port ranges
    source_address_prefix                      = string       #(Optional) CIDR or source IP range or * to match any IP
    source_address_prefixes                    = list(string) #(Optional) List of source address prefixes. Tags may not be used
    destination_address_prefix                 = string       #(Optional) CIDR or destination IP range or * to match any IP
    destination_address_prefixes               = list(string) #(Optional) List of destination address prefixes
    source_application_security_group_ids      = list(string) #(Optional) A List of source Application Security Group ID's
    destination_application_security_group_ids = list(string) #(Optional) A List of destination Application Security Group ID's
    description                                = string       #(Optional) A description for this rule. Restricted to 140 characters
  }))
  description = "(Optional) Additional NSG rules if required"
  default     = {}
}

variable "nsg_prefix" {
  type        = string
  description = "(Required) Prefix for the NSG name"
  default     = ""
}

variable "nsg_suffix" {
  type        = string
  description = "(Optional) Suffix for the NSG name"
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
//**********************************************************************************************
locals {
  timeout_duration = var.timeout
  nsg_name         = "${var.nsg_prefix}${var.name}${var.nsg_suffix}"
}
//**********************************************************************************************