module "snet_project102_prod_eastus_001" { // aks
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/subnet"

  name                 = var.snet_project102_prod_eastus_001.name
  resource_group_name  = module.vnet_project102_prod_eastus_001.resource_group_name
  virtual_network_name = module.vnet_project102_prod_eastus_001.name
  address_prefixes     = var.snet_project102_prod_eastus_001.address_prefixes
}