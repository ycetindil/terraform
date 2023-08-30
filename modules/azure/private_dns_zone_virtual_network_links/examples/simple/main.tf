module "private_dns_zone_virtual_network_link_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/private_dns_zone_virtual_network_link"

  name                  = var.private_dns_zone_virtual_network_link_xxx.name
  resource_group_name   = module.resource_group_xxx.name
  private_dns_zone_name = module.private_dns_zone_xx.name
  virtual_network_id    = module.virtual_network_xxx.id
}