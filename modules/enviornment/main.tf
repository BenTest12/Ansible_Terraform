terraform {

  required_version = ">=1.2.0"

}

# Creating an azure resource group for the project
resource "azurerm_resource_group" "project_rg" {
  name     = "${var.rg_name}-${var.rg_prefix}"
  location = var.rg_location
}

# Creating a virtual network inside the resource group
resource "azurerm_virtual_network" "project_vnet" {
  name                = "${var.rg_prefix}-vnet"
  address_space       = [var.vnet_address_range]
  location            = var.rg_location
  resource_group_name = azurerm_resource_group.project_rg.name
}

# Creating A subnet for the weight app application
resource "azurerm_subnet" "app-subnet" {
  name                 = "${var.rg_prefix}-app-subnet"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.project_vnet.name
  address_prefixes     = [var.app_subnet_address_range]
}

# Creating A subnet for the PostgreSQL Managed DB
resource "azurerm_subnet" "db-subnet" {
  name                 = "${var.rg_prefix}-db-subnet"
  resource_group_name  = azurerm_resource_group.project_rg.name
  virtual_network_name = azurerm_virtual_network.project_vnet.name
  address_prefixes     = [var.db_address_range]
  service_endpoints    = ["Microsoft.Storage"]


  # Delegate the private network to the PostgreSQL Flexible Managed DB
  delegation {
    name = "${var.rg_prefix}-endpoint"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", ]
    }
  }
}

# Creating the application network security group with rules to allow access via port 8080 and SSH
resource "azurerm_network_security_group" "weight_app_nsg" {
  name                = "${var.rg_prefix}-nsg"
  location            = var.rg_location
  resource_group_name = azurerm_resource_group.project_rg.name

  security_rule {
    name                       = "port_8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "port_22"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DENY_ALL"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Creating the database network security group with rules to allow communication between the app virtual machines and the db server
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = var.rg_location
  resource_group_name = azurerm_resource_group.project_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = var.app_subnet_address_range
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "port_5432"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "5432"
    destination_port_range     = "*"
    source_address_prefix      = var.app_subnet_address_range
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DENY_ALL"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associating the security groups to the subnets
resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  subnet_id                 = azurerm_subnet.app-subnet.id
  network_security_group_id = azurerm_network_security_group.weight_app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = azurerm_subnet.db-subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

# Creating load balancer

resource "azurerm_public_ip" "project_lb" {
  name                = "${var.rg_prefix}-ip"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name
  allocation_method   = "Static"
  domain_name_label   = "${azurerm_resource_group.project_rg.name}-personal-ip5"
}

resource "azurerm_lb" "app_load_balancer" {
  name                = "${var.rg_prefix}-lb"
  location            = azurerm_resource_group.project_rg.location
  resource_group_name = azurerm_resource_group.project_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.project_lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.app_load_balancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.project_rg.name
  name                           = "shellaccess"
  loadbalancer_id                = azurerm_lb.app_load_balancer.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50010
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_rule" "lb_rule_8080_IN" {
  resource_group_name            = azurerm_resource_group.project_rg.name
  loadbalancer_id                = azurerm_lb.app_load_balancer.id
  name                           = "lb_rule_8080_IN"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "app_lb_probe" {
  resource_group_name = azurerm_resource_group.project_rg.name
  loadbalancer_id     = azurerm_lb.app_load_balancer.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}

# Creating a public key for the group
resource "azurerm_ssh_public_key" "my_private_key" {
  name                = "my_private_key"
  resource_group_name = azurerm_resource_group.project_rg.name
  location            = azurerm_resource_group.project_rg.location
  public_key          = var.project_key
}

# Creating vmss
module "weight_app_vmss" {
  source                  = "../modules/VMSS"
  weight_app_name_prefix  = var.rg_prefix
  admin_user              = var.admin_user
  admin_password          = var.admin_password
  resource_group_location = azurerm_resource_group.project_rg.location
  resource_group_name     = azurerm_resource_group.project_rg.name
  weight_app_nsg_id       = azurerm_network_security_group.weight_app_nsg.id
  weight_app_subnet_id    = azurerm_subnet.app-subnet.id
  lb_bepool_id            = azurerm_lb_backend_address_pool.bepool.id
  lbnatpool_id            = azurerm_lb_nat_pool.lbnatpool.id
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "${azurerm_resource_group.project_rg.name}-5db.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.project_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnl" {
  name                  = "${azurerm_resource_group.project_rg.name}5.dns-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.project_vnet.id
  resource_group_name   = azurerm_resource_group.project_rg.name
}

resource "azurerm_postgresql_flexible_server" "postgres_server" {
  name                   = "${azurerm_resource_group.project_rg.name}-database-tf"
  resource_group_name    = azurerm_resource_group.project_rg.name
  location               = azurerm_resource_group.project_rg.location
  version                = "12"
  delegated_subnet_id    = azurerm_subnet.db-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_password
  zone                   = "1"

  storage_mb = 32768

  sku_name   = var.postgres_sku_name
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_vnl]

}

# Disabling SSL - requires restart in order to apply 
resource "azurerm_postgresql_flexible_server_configuration" "db-config-no-ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres_server.id
  value     = "off"
}

