variable "name" {
  type        = string
  description = "Name of the container registry"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "ACR name must contain only alphanumeric characters."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where the registry will be created"
}

variable "sku" {
  type        = string
  description = "SKU of the container registry"
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be one of: Basic, Standard, Premium."
  }
}

variable "admin_enabled" {
  type        = bool
  description = "Enable admin user for the registry"
  default     = false
}

variable "acr_pull_principals" {
  type        = list(string)
  description = "List of principals to grant pull access to the registry"
}

