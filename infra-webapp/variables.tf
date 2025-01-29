variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "westeurope"
}

variable "environment" {
  type        = string
  description = "Environment type"
  default     = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, prod"
  }
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "my-app"
}

variable "owner" {
  type        = string
  description = "Owner of the resources"
  default     = "your-name"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "docker_backend_image" {
  type        = string
  description = "Docker image for the backend container app"
}

variable "docker_frontend_image" {
  type        = string
  description = "Docker image for the frontend web app"
}

variable "docker_registry_url" {
  type        = string
  description = "Docker registry URL for the frontend web app"
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges allowed to access ACR"
  default     = []
}

#White list your IP on KV, Postgres, etc
#variable "my_ip" {
#  type        = string
#  description = "List of IP ranges allowed to access Key Vault"
#  default     = null
#}