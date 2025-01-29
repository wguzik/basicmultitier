variable "name" {
  type        = string
  description = "Name of the resource group"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,90}$", var.name))
    error_message = "Resource group name must be between 1 and 90 characters, and can only include alphanumeric, underscore, and hyphen characters."
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+[a-zA-Z]+[0-9]*$", var.location))
    error_message = "Location must be a valid Azure region name."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to the resource group"
  default     = {}
} 