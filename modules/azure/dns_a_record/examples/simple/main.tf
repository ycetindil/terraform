module "dns_a_record_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/dns_a_record"

  name                = var.dns_a_record_xxx.name
  resource_group_name = module.resource_group_xxx.name
  zone_name           = var.dns_a_record_xxx.zone_name
  ttl                 = var.dns_a_record_xxx.ttl
  records             = [module.public_ip_address_xxx.ip_address]
}