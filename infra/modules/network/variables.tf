variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "enable_nsg" {
  description = "Enable Network Security Groups for subnets"
  type        = bool
  default     = false
}

variable "custom_subnet_prefixes" {
  description = "Optional custom address prefixes for subnets"
  type        = map(list(string))
  default     = {}
} 