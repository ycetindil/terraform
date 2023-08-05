resource "azurerm_bastion_host" "bas" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = var.ip_configuration.name
    subnet_id = try(
      data.azurerm_subnet.existing_subnet.id,
      module.new_subnet.id,
      "'try' function could not find a valid 'subnet_id'!"
    )
    public_ip_address_id = try(
      data.azurerm_public_ip.existing_public_ip_address.id,
      module.new_public_ip_address.id,
      "'try' function could not find a valid 'public_ip_address_id'!"
    )
  }
}

# If existing 'subnet', retrieve its data
data "azurerm_subnet" "existing_subnet" {
  count = var.ip_configuration.subnet.existing != null ? 1 : 0

  name                 = var.ip_configuration.subnet.existing.name
  virtual_network_name = var.ip_configuration.subnet.existing.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.existing.resource_group_name
}

# If new 'subnet', create it
module "new_subnet" {
  source = "../subnet"
  count  = var.ip_configuration.subnet.new != null ? 1 : 0

  name             = "AzureBastionSubnet"
  virtual_network  = var.ip_configuration.subnet.new.virtual_network
  address_prefixes = var.ip_configuration.subnet.new.address_prefixes
}

# If existing 'public_ip_address', retrieve its data
data "azurerm_public_ip" "existing_public_ip_address" {
  count = var.ip_configuration.public_ip_address.existing != null ? 1 : 0

  name                = var.ip_configuration.existing_public_ip_address.name
  resource_group_name = var.ip_configuration.existing_public_ip_address.resource_group_name
}

# If new 'public_ip_address', create it
module "new_public_ip_address" {
  source = "../public_ip_address"
  count  = var.ip_configuration.public_ip_address.new != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.new.name
  location            = var.ip_configuration.public_ip_address.new.location
  resource_group_name = var.ip_configuration.public_ip_address.new.resource_group_name
  allocation_method   = var.ip_configuration.public_ip_address.new.allocation_method
  sku                 = var.ip_configuration.public_ip_address.new.sku
}