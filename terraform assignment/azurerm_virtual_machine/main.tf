resource "azurerm_resource_group" "rg" {
  for_each = var.vm
  name     = each.value.rg.name
  location = each.value.rg.location
}
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.vm
  name                = each.value.vnet.name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  address_space       = each.value.vnet.address_space
}
resource "azurerm_subnet" "sb" {
  for_each             = var.vm
  name                 = each.value.subnet.name
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = each.value.subnet.address_prefixes
}
resource "azurerm_public_ip" "pip" {
  for_each            = var.vm
  name                = each.value.public_ip.name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  allocation_method   = each.value.public_ip.allocation_method
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm
  name                = each.value.nic.name
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  ip_configuration {
    name                          = each.value.nic.ip_configuration.private_ip_address_allocation
    subnet_id                     = azurerm_subnet.sb[each.key].id
    private_ip_address_allocation = each.value.nic.ip_configuration.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }

}

resource "azurerm_linux_virtual_machine" "lnx" {
  for_each              = var.vm
  name = each.value.vm1.name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location = azurerm_resource_group.rg[each.key].location
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  size = each.value.vm1.size
  admin_username = each.value.vm1.admin_username
  admin_password = each.value.vm1.admin_password
  disable_password_authentication = each.value.vm1.disable_password_authentication


    os_disk {
    caching              = each.value.vm1.os_disk.caching
    storage_account_type = each.value.vm1.os_disk.storage_account_type
  }
  source_image_reference {
    publisher = each.value.vm1.source_image_reference.publisher
    offer     = each.value.vm1.source_image_reference.offer
    sku       = each.value.vm1.source_image_reference.sku
    version   = each.value.vm1.source_image_reference.version
  }
}
