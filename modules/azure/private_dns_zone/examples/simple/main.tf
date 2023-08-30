module "subnet_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/subnet"

  name                 = var.subnet_xxx.name
  resource_group_name  = module.resource_group_xxx.name
  virtual_network_name = module.virtual_network_xxx.name
  address_prefixes     = var.subnet_xxx.address_prefixes
}