provider "azurerm" {
  features {}
}
#------------------------------------------------------------------------------
variable "location" { default = "West Europe" }
variable "username" { default = "Moustapha" }
variable "password" { default = "Tbs@^##(&8888" }

# ----------------------------------------------------------------------------

resource "azurerm_resource_group" "test" {
  name     = "mous"
  location = var.location
}


#---------------------------------------------------------------------

resource "azurerm_storage_account" "test" {
  name                     = "test"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#-------------------------------------------------------------------
resource "azurerm_storage_container" "test" {
  name                  = "sadvi"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

#------------------------------------------------------------------------
resource "azurerm_virtual_network" "test" {
  name                = "test"
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name

}

#-------------------------------------------------------------------------
resource "azurerm_subnet" "test" {
  name                 = "test"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["192.168.2.0/24"]
}
#------------------------------------------------------------------------------
resource "azurerm_subnet" "test2" {
  name                 = "test2"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["192.168.3.0/24"]
}

resource "azurerm_subnet" "test3" {
  name                 = "test3"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["192.168.4.0/24"]
}

resource "azurerm_network_interface" "test" {
  name                = "test"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
  ip_configuration {
    name                          = "moustapha1"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "test2" {
  name                = "test2"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
  ip_configuration {
    name                          = "moustapha2"
    subnet_id                     = azurerm_subnet.test2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "test3" {
  name                = "test3"
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
  ip_configuration {
    name                          = "moustapha3"
    subnet_id                     = azurerm_subnet.test3.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                            = "machineTest"
  location                        = azurerm_resource_group.test.location
  resource_group_name             = azurerm_resource_group.test.name
  network_interface_ids           = [azurerm_network_interface.test.id]
  size                            = "Standard_B1s"
  computer_name                   = "pc1"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk {
    name                 = "disk1"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

}

