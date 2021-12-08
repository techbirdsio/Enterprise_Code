// Required Variables
variable "resource_group" {
  type = map(object({
    name     = string
    location = string
  }))
  description = "(Required) Resource Group Name and Location"
  default     = {}
}


// Optional Variables
variable "resource_group_prefix" {
  type        = string
  description = "(Required) Prefix for the resource group name"
  default     = ""
}

variable "resource_group_suffix" {
  type        = string
  description = "(Optional) Suffix for the resource group name"
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
  default     = "90m"
}


// Local Values
locals {
  timeout_duration = var.timeout
}

