resource "azurerm_public_ip" "sonar" {
  name                = "pip-sonar"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "sonar" {
  name                = "nic-sonar"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.sonar.id
  }
}

resource "azurerm_linux_virtual_machine" "sonar" {
  name                  = "vm-sonar"
  location              = local.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = local.sonar_size
  zone                  = "1"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.sonar.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
