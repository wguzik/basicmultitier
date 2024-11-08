variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "server_name" {
  type        = string
  description = "Name of the PostgreSQL server"
}

variable "admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL server"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL server"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Name of the PostgreSQL database"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where PostgreSQL server will be deployed"
}

variable "private_dns_zone_id" {
  type        = string
  description = "ID of the private DNS zone where PostgreSQL server will be deployed"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault where PostgreSQL credentials are stored"
}

