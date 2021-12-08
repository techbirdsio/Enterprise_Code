// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist"
}

variable "location" {
  type        = string
  description = "(Required) The supported Azure location where the resource exists"
}

variable "name" {
  type        = string
  description = "(Required) Specifies the Name of the Private Endpoint"
}

/* variable "private_connection_resource_name" {
  type        = string
  description = "(Required) Specifies the Name of the target resource for which Private Endpoint will be deployed"
} */

variable "private_connection_resource_id" {
  type        = string
  description = "(Required) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to"
}

variable "subnet_id" {
  type        = string
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint"
}


// Optional Variables
# Private DNS Zone
variable "create_dns_zone" {
  type        = bool
  description = "(Optional) Create/Not the private DNS zone"
  default     = false
}
variable "dns_zone_resource_group" {
  type        = string
  description = "(Optional) Resource group where the DNS zone should be created"
  default     = null
}
variable "dns_zone_name" {
  type        = string
  description = "(Optional) The name of the Private DNS Zone"
  default     = null
}
variable "virtual_network_id" {
  type        = string
  description = "(Optional) The Resource ID of the Virtual Network that should be linked to the DNS Zone"
  default     = null
}
variable "is_manual_connection" {
  type        = bool
  description = "(Optional) Does the Private Endpoint require Manual Approval from the remote resource owner?"
  default     = false
}

# Private endpoint connection
variable "subresource_names" {
  type        = list(string)
  description = "(Optional) A list of subresource names which the Private Endpoint is able to connect to"
  default     = []
}
variable "request_message" {
  type        = string
  description = "(Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. Only valid if is_manual_connection is set to true"
  default     = null
}
variable "private_ip_address" {
  type        = string
  description = "(Computed) The private IP address associated with the private endpoint"
  default     = null
}

variable "private_endpoint_prefix" {
  type        = string
  description = "(Required) Prefix for Postgresql server name"
  default     = ""
}

variable "private_endpoint_suffix" {
  type        = string
  description = "(Optional) Suffix for AKS cluster name"
  default     = ""
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}
variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}
variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}


// Local Values
//**********************************************************************************************
locals {
  timeout_duration      = "1h"
  private_endpoint_name = "${var.private_endpoint_prefix}${var.name}${var.private_endpoint_suffix}"
  private_dns_zone_name = var.create_dns_zone ? azurerm_private_dns_zone.dns_zone[0].name : ""
  private_dns_zone_id   = var.create_dns_zone ? azurerm_private_dns_zone.dns_zone[0].id : ""
}
//**********************************************************************************************