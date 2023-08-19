variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Custom Domain.
    Possible values must be between 2 and 260 characters in length, must begin with a letter or number, end with a letter or number and contain only letters, numbers and hyphens.
    Changing this forces a new Front Door Custom Domain to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_profile_id" {
  description = <<EOD
    (Required) The ID of the Front Door Profile.
    Changing this forces a new Front Door Profile to be created.
  EOD
  type        = string
}

variable "host_name" {
  description = <<EOD
    (Required) The host name of the domain.
    The host_name field must be the FQDN of your domain (e.g. contoso.fabrikam.com).
    Changing this forces a new Front Door Custom Domain to be created.
  EOD
  type        = string
}

variable "dns_zone_id" {
  description = <<EOD
    (Optional) The ID of the Azure DNS Zone which should be used for this Front Door Custom Domain.
    If you are using Azure to host your DNS domains, you must delegate the domain provider's domain name system (DNS) to an Azure DNS Zone. For more information, see https://learn.microsoft.com/azure/dns/dns-delegate-domain-azure-dns.
    Otherwise, if you're using your own domain provider to handle your DNS, you must validate the Front Door Custom Domain by creating the DNS TXT records manually.
  EOD
  default     = null
  type        = string
}

variable "tls" {
  description = <<EOD
    (Required) A tls block as defined below.
    A tls block supports the following:
    - certificate_type - (Optional) Defines the source of the SSL certificate.
      Possible values include CustomerCertificate and ManagedCertificate.
      Defaults to ManagedCertificate.
      NOTE: It may take up to 15 minutes for the Front Door Service to validate the state and Domain ownership of the Custom Domain.
    - minimum_tls_version - (Optional) TLS protocol version that will be used for Https.
      Possible values include TLS10 and TLS12.
      Defaults to TLS12.
    - cdn_frontdoor_secret - (Optional) Key of the Front Door Secret.
  EOD
  type = object({
    certificate_type     = optional(string)
    minimum_tls_version  = optional(string)
    cdn_frontdoor_secret = optional(string)
  })
}