terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "rg-zerotrust" {
  name     = "zerotrust"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet-zerotrust" {
  name                = "my-virtual-network"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location
  address_space       = ["172.22.0.0/16"]
}

resource "azurerm_subnet" "subnet-zerotrust" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg-zerotrust.name
  virtual_network_name = azurerm_virtual_network.vnet-zerotrust.name
  address_prefixes     = ["172.22.0.0/24"]
}

resource "azurerm_network_security_group" "sg-zerotrust" {
  name                = "zero-trust-security-group"
  location            = azurerm_resource_group.rg-zerotrust.location
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
}
 
resource "azurerm_network_security_rule" "sr-ssh-access" {
  name                        = "ssh-access"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "104.28.153.88/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-zerotrust.name
  network_security_group_name = azurerm_network_security_group.sg-zerotrust.name
}
resource "azurerm_network_security_rule" "sr-rdp-access" {
  name                        = "rdp-access"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "104.28.153.88/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-zerotrust.name
  network_security_group_name = azurerm_network_security_group.sg-zerotrust.name
}
resource "azurerm_network_security_rule" "outbound-access" {
  name                        = "outbound-access"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-zerotrust.name
  network_security_group_name = azurerm_network_security_group.sg-zerotrust.name
}