module "dns_cname_record_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/dns_cname_record"

  name                = var.dns_cname_record_xxx.name
  resource_group_name = module.resource_group_xxx.name
  zone_name           = var.dns_cname_record_xxx.zone_name
  ttl                 = var.dns_cname_record_xxx.ttl
  record              = var.dns_cname_record_xxx.record
}