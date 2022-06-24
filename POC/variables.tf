# --- variables

variable "RG" {
  description = "resource group name"
}

variable "tags" {
  default = "enviroment"
  description = "tags"
}

variable "VnetName" {
  default = "Vnet"
  description = "VnetName"
}

variable "address_space" {
  type    = list(any)
  # default = ["10.10.0.0/16"]
  description = "address space"

}

variable "addr_prefixes_Web_Tier" {
  type    = list(any)
  # default = ["10.10.1.0/24"]
  description = "address prefixes"

}

variable "addr_prefixes_Data_Tier" {
  type    = list(any)
  # default = ["10.10.2.0/24"]
  description = "address prefixes"

}

variable "location" {
  type        = string
  # default     = "australiaeast"
  description = "Azure location of terraform server environment"

}

variable "admin_user_name" {
  type        = string
  # default     = "admin_user_name"
  description = "user name for vm login"
}
variable "admin_password" {
  type        = string
  # default     = "Input your password here"
  description = "password for vm login"

}

variable "pg_user" {
  # default = ""
  description = "pg_user"
}

variable "pg_pass" {
  # default = ""
  description = "pg_pass"
}

variable "dns_postgresSQL" {
  type        = string
  # default     = "Input your password here"
  description = "DNS name for postgres"

}

variable "ip_connecter_via_RDP" {
  type        = string
  # default     = "Input your password here"
  description = "IP address from which yo will connect to controller"

}
