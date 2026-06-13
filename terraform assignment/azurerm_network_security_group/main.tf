resource "azurerm_network_security_group" "ng" {
  for_each = var.nsg
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  location = each.value.location

  security_rule={
      name                       = each.value.security_rule.name
      priority                   = each.value.security_rule.priority
      direction                  = each.value.security_rule.direction
      access                     = each.value.security_rule.access
      protocol                   = each.value.security_rule.protocol
      source_port_range          = each.value.security_rule.source_port_range
      destination_port_range     = each.value.security_rule.destination_port_range
      source_address_prefix      = each.value.security_rule.source_address_prefix
      destination_address_prefix = each.value.security_rule.source_address_prefix
      } 
  
}