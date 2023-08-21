######################
### Ubuntu Network ###
######################
resource "azurerm_public_ip" "pubip-ubuntu" {
  name                = "ubuntu-public-ip"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vnic-ubuntu" {
  name                = "ubuntu-nic"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location

  ip_configuration {
    name                          = "ubuntu-nic-config"
    subnet_id                     = azurerm_subnet.subnet-zerotrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.22.0.7"
    public_ip_address_id          = azurerm_public_ip.pubip-ubuntu.id
  }
}
resource "azurerm_network_interface_security_group_association" "ubuntu-sga" {
  network_interface_id      = azurerm_network_interface.vnic-ubuntu.id
  network_security_group_id = azurerm_network_security_group.sg-zerotrust.id
}
#############
## Ubuntu ###
#############
resource "azurerm_virtual_machine" "ubuntu" {
  name                             = "ubuntu"
  resource_group_name              = azurerm_resource_group.rg-zerotrust.name
  location                         = azurerm_resource_group.rg-zerotrust.location
  vm_size                          = "Standard_DS2_v2"
  network_interface_ids            = [azurerm_network_interface.vnic-ubuntu.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "ubuntu"
    admin_username = "doecon"
    admin_password = "y&7CGB*6&fizH5ffzs7^"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  # az vm image list --all --publisher Canonical |     jq '[.[] | select(.sku=="23_04")]| max_by(.version)'
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-lunar"
    sku       = "23_04"
    version   = "latest"
  }

  storage_os_disk {
    name              = "ubuntuos-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "60"
  }

  tags = {
    environment = "dev"
  }
}
output "ubuntu_public_ip_address" {
  value = azurerm_public_ip.pubip-ubuntu.*.ip_address
}
