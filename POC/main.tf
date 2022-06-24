provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.2.2"
}

# azurerm_resource_group
resource "azurerm_resource_group" "RG" {
  name     = var.RG 
  location = var.location
  tags = {
    name = var.tags
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.VnetName
  address_space       = var.address_space
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
    tags ={
    name = var.tags
  }
}

# Create a subnet for the data base
resource "azurerm_subnet" "Data_Tier" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.addr_prefixes_Data_Tier 
  service_endpoints = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action",]
    }
  }
}

# Create a subnet for the app servers the web tier
resource "azurerm_subnet" "Web_Tier" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.addr_prefixes_Web_Tier
}


# Azure Public Ip for Load Balancer
resource "azurerm_public_ip" "vmPublicIP" {
  name                = "winPupIP"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   ="bentest1212-weight-app-project-personal-ip5"

}

# azurerm_network_interface
resource "azurerm_network_interface" "network_int_web_Tier" {
  name                = "network_int_web"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Web_Tier.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id =  azurerm_public_ip.vmPublicIP.id
  }
}

# azurerm_windows_virtual_machine
resource "azurerm_windows_virtual_machine" "vm_frontend" {
  name                = "winApp"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "Standard_B2s" 
  admin_username      = var.admin_user_name
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.network_int_web_Tier.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# azurerm_subnet_network_security_group_association

resource "azurerm_subnet_network_security_group_association" "app_nsg_association_backend" {
  subnet_id                 = azurerm_subnet.Data_Tier.id
  network_security_group_id = azurerm_network_security_group.NSG_backend.id
}


# azurerm_subnet_network_security_group_association

resource "azurerm_subnet_network_security_group_association" "app_nsg_association_frontend" {
  subnet_id                 = azurerm_subnet.Web_Tier.id
  network_security_group_id = azurerm_network_security_group.NSG_frontend.id
}


# azurerm_network_security_group

resource "azurerm_network_security_group" "NSG_frontend" {
  name                = "NSG_web"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "rdp"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = var.ip_connecter_via_RDP # "*" #put here access from your ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_8080"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "Deny"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_security_group" "NSG_backend" {
  name                = "NSG_db"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name



  security_rule {
    name                       = "Postgres"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = var.addr_prefixes_Web_Tier[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "controller access"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5985"
    destination_port_range     = "5985"
    source_address_prefix      = var.addr_prefixes_Web_Tier[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

#  azurerm_private_dns_zone

resource "azurerm_private_dns_zone" "Flexibale_Postgres_DataBase_DNS" {
  name                = "FlexiblePostgresTestVdbForPostgrestest.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.RG.name
  
}

#  azurerm_postgresql_flexible_server

resource "azurerm_postgresql_flexible_server" "PosrgreSQLFlexibleDataServer" {
  name                   = var.dns_postgresSQL #"dbofpostgressqlserverforwebweigthapp"
  resource_group_name    = azurerm_resource_group.RG.name
  location               = azurerm_resource_group.RG.location
  version                = "13" # "12"
  delegated_subnet_id    = azurerm_subnet.Data_Tier.id
  private_dns_zone_id    = azurerm_private_dns_zone.Flexibale_Postgres_DataBase_DNS.id
  administrator_login    = var.pg_user
  administrator_password = var.pg_pass
  zone                   = "1"
  create_mode            = "Default"
  storage_mb             = 32768


  sku_name = "B_Standard_B1ms" 
    
    
    tags = {
    name = var.tags
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.someTestingWithDnsLink] #my edit

}

#  azurerm_postgresql_flexible_server_database

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = "db"
  server_id = azurerm_postgresql_flexible_server.PosrgreSQLFlexibleDataServer.id
  collation = "en_US.utf8"
  charset   = "utf8"

}

#  azurerm_postgresql_flexible_server_firewall_rule

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgres" {
  name      = "postgres"
  server_id = azurerm_postgresql_flexible_server.PosrgreSQLFlexibleDataServer.id

  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"

}

#  azurerm_postgresql_flexible_server_configuration

resource "azurerm_postgresql_flexible_server_configuration" "flexible_server_configuration" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.PosrgreSQLFlexibleDataServer.id
  value     = "off"

}

#  azurerm_private_dns_zone_virtual_network_link

resource "azurerm_private_dns_zone_virtual_network_link" "someTestingWithDnsLink" { 
  name                  = "someTestingWithDnsLink"
  private_dns_zone_name = azurerm_private_dns_zone.Flexibale_Postgres_DataBase_DNS.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.RG.name

}