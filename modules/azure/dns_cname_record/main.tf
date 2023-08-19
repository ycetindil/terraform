# Enables you to manage DNS CNAME Records within Azure DNS.
# NOTE: The Azure DNS API has a throttle limit of 500 read (GET) operations per 5 minutes - whilst the default read timeouts will work for most cases - in larger configurations you may need to set a larger read timeout then the default 5min. Although, we'd generally recommend that you split the resources out into smaller Terraform configurations to avoid the problem entirely.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record
resource "azurerm_dns_cname_record" "dns_cname_record" {
  name                = var.name
  resource_group_name = var.resource_group_name
  zone_name           = var.zone_name
  ttl                 = var.ttl
  record              = var.record
}