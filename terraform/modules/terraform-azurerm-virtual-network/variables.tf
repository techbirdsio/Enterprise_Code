// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network"
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created"
}

variable "vnet" {
  type = map(object({
    name          = string       #The name of the virtual network
    address_space = list(string) #(Required) The address space that is used the virtual network
  }))
  description = "(Required) Vnet name and CIDR block details"
  default     = {}
}


//Optional Variables
variable "ddos_protection_plan" {
  type = map(object({
    id     = string #(Required) The Resource ID of DDoS Protection Plan
    enable = bool   #(Required) Enable/disable DDoS Protection Plan on Virtual Network
  }))
  description = "(Optional) A ddos_protection_plan block"
  default     = {}
}

variable "dns_servers" {
  type        = list(string)
  description = "(Optional) List of IP addresses of DNS servers"
  default     = []
}

# Subnet
variable "subnet" {
  type = map(object({
    name           = string #(Required) The name of the subnet
    address_prefix = string #(Required) The address prefix to use for the subnet
    security_group = string #(Optional) The Network Security Group to associate with the subnet
  }))
  description = "(Optional) One or more Subnets blocks"
  default     = {}
}

variable "vnet_prefix" {
  type        = string
  description = "(Required) Prefix for the VNET name"
  default     = ""
}

variable "vnet_suffix" {
  type        = string
  description = "(Optional) Suffix for the VNET name"
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

