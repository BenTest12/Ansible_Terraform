variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_prefix" {
  type        = string
  description = "Resource group name prefix"
}

variable "rg_location" {
  type        = string
  description = "Location of the resource group"
}

variable "vnet_address_range" {
  type        = string
  description = "VNET IP Address Range"
}

variable "app_subnet_address_range" {
  type        = string
  description = "Application Subnet Range"
}

variable "db_address_range" {
  type        = string
  description = "DB Subnet Range"
}

variable "my_ip" {
  type        = string
  description = "My WAN Address , used to access the vmss via ssh"
}

variable "project_key" {
  type        = string
  description = "My personal public key , used to access the vmss via ssh"
}

variable "admin_user" {
  type        = string
  description = "Ubuntu machine administrator user"
}

variable "admin_password" {
  type        = string
  description = "Ubuntu machine administrator password"
}

variable "postgres_admin_username" {
  type        = string
  description = "PostgreSQL DB administrator username"
}

variable "postgres_password" {
  type        = string
  description = "PostgreSQL DB administrator password"
}

variable "postgres_sku_name" {
  type        = string
  description = "PostgreSQL DB server SKU"
}
