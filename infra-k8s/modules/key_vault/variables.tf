variable "name" {
  type        = string
  description = "Name of the Key Vault"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.name))
    error_message = "Key Vault name must be between 3 and 24 characters long and can only contain alphanumeric characters and hyphens."
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "allowed_ips" {
  type        = list(string)
  description = "List of IP addresses that can access the Key Vault"
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs that can access the Key Vault"
  default     = []
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "Private DNS Zone ID for Key Vault private endpoint"
  type        = string
  default     = null
}
