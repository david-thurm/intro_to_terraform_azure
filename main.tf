terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.62.1"
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
  name                = "nsg-rdp"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location

  security_rule {
    name                       = "ssh-rdp"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22,3389"
    source_address_prefix      = "110.20.29.28"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "dev"
}
