# Manages a Front Door (standard/premium) Custom Domain.
# IMPORTANT: If you are using Terraform to manage your DNS Auth and DNS CNAME records for your Custom Domain you will need to add configuration blocks for both the azurerm_dns_txt_record(see the Example DNS Auth TXT Record Usage below) and the azurerm_dns_cname_record(see the Example CNAME Record Usage below) to your configuration file.
# IMPORTANT: You must include the depends_on meta-argument which references both the azurerm_cdn_frontdoor_route and the azurerm_cdn_frontdoor_security_policy that are associated with your Custom Domain. The reason for these depends_on meta-arguments is because all of the resources for the Custom Domain need to be associated within Front Door before the CNAME record can be written to the domains DNS, else the CNAME validation will fail and Front Door will not enable traffic to the Domain.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain
resource "azurerm_cdn_frontdoor_custom_domain" "cdn_frontdoor_custom_domain" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  host_name                = var.host_name
  dns_zone_id              = var.dns_zone_id

  tls {
    certificate_type        = var.tls.certificate_type
    minimum_tls_version     = var.tls.minimum_tls_version
    cdn_frontdoor_secret_id = var.tls.cdn_frontdoor_secret_id
  }
}