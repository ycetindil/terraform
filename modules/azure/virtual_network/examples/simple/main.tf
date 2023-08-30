module "virtual_network_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/virtual_network"

  name                = var.virtual_network_xxx.name
  location            = var.virtual_network_xxx.location
  resource_group_name = module.resource_group_xxx.name
  address_space       = var.virtual_network_xxx.address_space
}