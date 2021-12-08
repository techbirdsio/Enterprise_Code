// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the route table"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists"
}

variable "name" {
  type        = string
  description = "(Required) The name of the route table"
}

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "(Optional) Boolean flag which controls propagation of routes learned by BGP on that route table"
  default     = false
}

// Optional Variables
variable "inline_route" {
  type = list(object({
      name                   = string #(Required) The name of the route
      address_prefix         = string #(Required) The destination CIDR to which the route applies
      next_hop_type          = string #(Required) The type of Azure hop the packet should be sent to
      next_hop_in_ip_address = string #(Optional) Contains the IP address packets should be forwarded to
}))
description = "(Optional) List of objects representing Inline routes"
default = []
}

variable "standalone_route" {
  type = map(object({
    name                   = string #(Required) The name of the route
    address_prefix         = string #(Required) The destination CIDR to which the route applies
    next_hop_type          = string #(Required) The type of Azure hop the packet should be sent to
    next_hop_in_ip_address = string #(Optional) Contains the IP address packets should be forwarded 
  }))
  description = "(Optional) Standalone routes"
  default     = {}
}

variable "route_table_prefix" {
  type        = string
  description = "(Required) Prefix for the route table name"
  default     = ""
}

variable "route_table_suffix" {
  type        = string
  description = "(Optional) Suffix for the route table name"
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