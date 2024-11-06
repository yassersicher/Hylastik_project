 variable "prefix" {
  default = "server"
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "security_group" {
  name                = "allow_port_connection"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  # Inbound Rule for Port 8088 for keycloak
  security_rule {
    name                       = "Allow-8088"
    priority                  = 100
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "8088"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }

  # Inbound Rule for Port 8001 for nginx
  security_rule {
    name                       = "Allow-8001"
    priority                  = 101
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "8001"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "interface" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    network_security_group_id     = azurerm_network_security_group.security_group.id 
   
  }
  
}
resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.resource_group.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
output "vm_name" {
  value = azurerm_virtual_machine.virtual_machine.name
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}