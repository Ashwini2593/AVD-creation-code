provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  resource_provider_registrations = "none"
}
# Resource Group
data "azurerm_resource_group" "avd" {
  name     = var.resource_group_name
  //location = var.location
}

# Virtual Network

data "azurerm_virtual_network" "existing_vnet" {
  name                = var.vnet_name  # Replace with your VNet name
  resource_group_name =  data.azurerm_resource_group.avd.name # Replace with your resource group name
}

/*
data "azurerm_virtual_network" "vnet" {
  name                = data.azurerm_resource_group.avd
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name
}
*/

# Subnet
data "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.avd.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  //address_prefixes     = ["10.0.1.0/24"]
}



# Azure Virtual Desktop Host Pool
resource "azurerm_virtual_desktop_host_pool" "host_pool" {
  name                = "avd-host-pool"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  friendly_name       = "MyAVDHostPool"
  type                = "Pooled"
  load_balancer_type  = "BreadthFirst"
  //max_sessions        = 5
}

# Application Group
resource "azurerm_virtual_desktop_application_group" "desktop_app_group" {
  name                = "avd-app-group"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  host_pool_id        = azurerm_virtual_desktop_host_pool.host_pool.id
  type                = "Desktop"
}

/*
# Assignments (Example for a User)
resource "azurerm_virtual_desktop_application_group_assignment" "assignment" {
  application_group_id = azurerm_virtual_desktop_application_group.desktop_app_group.id
  user_principal_name  = "deepti.singh@informationtechconsultants.co.uk" # Replace with the appropriate user
}
*/

# Virtual Machine for AVD
resource "azurerm_windows_virtual_machine" "avd_vm" {
  name                = "deepti-avd-vm"
  resource_group_name = data.azurerm_resource_group.avd.name
  location            = data.azurerm_resource_group.avd.location
  size                = "Standard_DS2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!" # Replace with a secure password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    name              = "avd-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-pro"
    version   = "latest"
  }
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "avd-nic"
  location            = data.azurerm_resource_group.avd.location
  resource_group_name = data.azurerm_resource_group.avd.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Example usage: Output the details of the existing subnet
output "subnet_id" {
  value = data.azurerm_subnet.subnet.id
}

output "subnet_address_prefixes" {
  value = data.azurerm_subnet.subnet.address_prefixes
}