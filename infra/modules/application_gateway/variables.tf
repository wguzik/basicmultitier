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
  description = "Name of the application gateway"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where application gateway will be deployed"
}

variable "web_app_name" {
  type        = string
  description = "Name of the web app to route traffic to"
}

variable "web_app_ip" {
  type        = string
  description = "IP address of the web app"
} 