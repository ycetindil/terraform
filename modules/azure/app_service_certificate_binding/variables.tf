variable "certificate_id" {
  description = <<EOD
    (Required) The ID of the certificate to bind to the custom domain.
    Changing this forces a new App Service Certificate Binding to be created.
  EOD
  type        = string
}

variable "hostname_binding_id" {
  description = <<EOD
    (Required) The ID of the Custom Domain/Hostname Binding.
    Changing this forces a new App Service Certificate Binding to be created.
  EOD
  type        = string
}

variable "ssl_state" {
  description = <<EOD
    (Required) The type of certificate binding.
    Allowed values are IpBasedEnabled or SniEnabled.
    Changing this forces a new App Service Certificate Binding to be created.
  EOD
  type        = string
}