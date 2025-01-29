variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "name" {
  type        = string
  description = "Name of the web app"
}

variable "docker_image_name" {
  type        = string
  description = "Docker image for the web app"
}

variable "docker_registry_url" {
  type        = string
  description = "Docker registry URL"
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan. Possible values include B1, B2, B3, D1, F1, FREE, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3"
  type        = string
  default     = "P0v3" # Production v2 tier with 1 core
}

variable "os_type" {
  description = "The O/S type for the App Services Plan. Possible values include Windows, Linux, and WindowsContainer"
  type        = string
  default     = "Linux"
}

variable "backend_url" {
  type        = string
  description = "URL of the backend service"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where web app will be deployed"
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of the private DNS zone for the web app"
  default     = null
}

variable "app_settings" {
  type        = map(string)
  description = "Map of app settings for the web app"
  default     = {}
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Whether to enable private endpoint for the web app"
  default     = false
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "ID of the subnet where private endpoint will be deployed"
  default     = null
}

