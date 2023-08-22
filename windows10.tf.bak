#########################
## Windows 10 Network ###
#########################
resource "azurerm_public_ip" "pubip-windows10" {
  name                = "windows10-public-ip"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vnic-windows10" {
  name                = "windows10-nic"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location

  ip_configuration {
    name                          = "windows10-nic-config"
    subnet_id                     = azurerm_subnet.subnet-zerotrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.22.0.8"
    public_ip_address_id          = azurerm_public_ip.pubip-windows10.id
  }
}
#################
## Windows 10 ###
#################
resource "azurerm_virtual_machine" "windows10" {
  name                             = "windows10"
  resource_group_name              = azurerm_resource_group.rg-zerotrust.name
  location                         = azurerm_resource_group.rg-zerotrust.location
  vm_size                          = "Standard_DS2_v2"
  network_interface_ids            = [azurerm_network_interface.vnic-windows10.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "windows10"
    admin_username = "doecon"
    admin_password = "y&7CGB*6&fizH5ffzs7^"
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = "Central Standard Time"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "rs5-enterprisen-standard-g2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "windows10os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  tags = {
    environment = "dev"
  }
}
output "windows10_public_ip_address" {
  value = azurerm_public_ip.pubip-windows10.*.ip_address
}
