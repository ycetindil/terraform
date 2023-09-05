module "vnet_project102_prod_eastus_001" { // app
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/virtual_network"

  name                = var.vnet_project102_prod_eastus_001.name
  resource_group_name = module.rg_project102_prod_eastus_001.name
  address_space       = var.vnet_project102_prod_eastus_001.address_space
  location            = var.vnet_project102_prod_eastus_001.location
}