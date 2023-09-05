output "name" {
	description = "The name of the virtual network."
	value = azurerm_virtual_network.virtual_network.name
}

output "resource_group_name" {
	description = "The name of the resource group of the virtual network."
	value = azurerm_virtual_network.virtual_network.resource_group_name
}