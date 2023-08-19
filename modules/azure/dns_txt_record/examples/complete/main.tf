module "dns_txt_record_xxx" {
  source = "./modules/dns_txt_record"

  name                = "asuid.${var.dns_txt_record_xxx.subdomain_name}"
  resource_group_name = module.resource_group_xxx.name
  zone_name           = var.dns_txt_record_xxx.zone_name
  ttl                 = var.dns_txt_record_xxx.ttl

  record = {
    value = module.windows_web_app_xxx.custom_domain_verification_id
  }

  tags = try(var.dns_txt_record_xxx.tags, null)
}