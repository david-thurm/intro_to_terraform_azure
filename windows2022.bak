################################
## Domain Controller Network ###
################################
resource "azurerm_public_ip" "pubip-dc01" {
  name                = "dc01-public-ip"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vnic-dc01" {
  name                = "dc01-nic"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location

  ip_configuration {
    name                          = "dc01-nic-config"
    subnet_id                     = azurerm_subnet.subnet-zerotrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.22.0.6"
    public_ip_address_id          = azurerm_public_ip.pubip-dc01.id
  }
}
########################
## Domain Controller ###
########################
resource "azurerm_virtual_machine" "dc01" {
  name                  = "dc01"
  resource_group_name   = azurerm_resource_group.rg-zerotrust.name
  location              = azurerm_resource_group.rg-zerotrust.location
  vm_size               = "Standard_DS2_v2"
  network_interface_ids = [azurerm_network_interface.vnic-dc01.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "dc01"
    admin_username = "doecon"
    admin_password = "y&7CGB*6&fizH5ffzs7^"
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = "Central Standard Time"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "windows2022os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
}
output "dc01_public_ip_address" {
  value = azurerm_public_ip.pubip-dc01.*.ip_address
}
