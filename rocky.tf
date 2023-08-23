#####################
### Rocky Network ###
#####################
resource "azurerm_public_ip" "pubip-rocky" {
  name                = "rocky-public-ip"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vnic-rocky" {
  name                = "rocky-nic"
  resource_group_name = azurerm_resource_group.rg-zerotrust.name
  location            = azurerm_resource_group.rg-zerotrust.location

  ip_configuration {
    name                          = "rocky-nic-config"
    subnet_id                     = azurerm_subnet.subnet-zerotrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.22.0.9"
    public_ip_address_id          = azurerm_public_ip.pubip-rocky.id
  }
}
resource "azurerm_network_interface_security_group_association" "rocky-sga" {
  network_interface_id      = azurerm_network_interface.vnic-rocky.id
  network_security_group_id = azurerm_network_security_group.sg-zerotrust.id
}
#############
### Rocky ###
#############
resource "azurerm_virtual_machine" "rocky" {
  name                             = "rocky"
  resource_group_name              = azurerm_resource_group.rg-zerotrust.name
  location                         = azurerm_resource_group.rg-zerotrust.location
  vm_size                          = "Standard_DS2_v2"
  network_interface_ids            = [azurerm_network_interface.vnic-rocky.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

 plan {
    publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
    name      = "rockylinux-9"
    product   = "rockylinux-9"
  }
  os_profile {
    computer_name  = "rocky"
    admin_username = "doecon"
    admin_password = "y&7CGB*6&fizH5ffzs7^"
    custom_data = filebase64("./nginxserver_rocky_deploy.sh")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  # az vm image list --all --publisher erockyenterprisesoftwarefoundationinc1653071250513 | jq '[.[] | select(.sku=="rockylinux-9")]| max_by(.version)'
  storage_image_reference {
    publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
    offer     = "rockylinux-9"
    sku       = "rockylinux-9"
    version   = "latest"
  }

  storage_os_disk {
    name              = "rockyos-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = "60"
  }
    

  tags = {
    environment = "dev"
  }
}

output "rocky_public_ip_address" {
  value = azurerm_public_ip.pubip-rocky.*.ip_address
}
