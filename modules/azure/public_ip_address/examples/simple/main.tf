module "public_ip_address_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/public_ip_address"

  name                = var.public_ip_address_xxx.name
  location            = var.public_ip_address_xxx.location
  resource_group_name = module.resource_group_xxx.name
  allocation_method   = var.public_ip_address_xxx.allocation_method
  sku                 = var.public_ip_address_xxx.sku
}