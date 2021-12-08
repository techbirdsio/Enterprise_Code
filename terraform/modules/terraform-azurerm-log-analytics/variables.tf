// Common Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the Log Analytics workspace/Solution is created"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists."
}


// Log analytics workspace
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'"
}

variable "sku" {
  type        = string
  description = "(Required) Specifies the Sku of the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730"
  default     = 30
}


// Log analytics solution
variable "workspace_resource_id" {
  type        = string
  description = "(Optional) The full resource ID of the Log Analytics workspace with which the solution will be linked"
  default     = null
}

variable "workspace_name" {
  type        = string
  description = "(Optional) The full name of the Log Analytics workspace with which the solution will be linked"
  default     = null
}

variable "solutions" {
  type = map(object({
    publisher = string #(Required) The publisher of the solution
    product   = string #(Required) The product name of the solution
  }))
  description = "(Optional) A plan block"
  default     = {}
}


// Optional Variables
variable "workspace_prefix" {
  type        = string
  description = "(Optional) Prefix for Postgresql server name"
  default     = ""
}

variable "workspace_suffix" {
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
locals {
  timeout_duration = "1h"
  workspace_name   = "${var.workspace_prefix}${var.name}${random_string.workspace_name.result}${var.workspace_suffix}"
}