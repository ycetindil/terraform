variable "name" {
  description = <<EOD
    (Required) The name of the Application Gateway.
    Changing this forces a new resource to be created
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to the Application Gateway should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The Azure region where the Application Gateway should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "backend_address_pools" {
  description = <<EOT
    (Required) One or more backend_address_pool blocks as defined below.
    A backend_address_pool block supports the following:
    - name - (Required) The name of the Backend Address Pool.
    - fqdns - (Optional) A list of FQDN's which should be part of the Backend Address Pool.
    - ip_addresses - (Optional) A list of IP Addresses which should be part of the Backend Address Pool.
  EOT
  type = map(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settingses" {
  description = <<EOD
    (Required) One or more backend_http_settings blocks as defined below.
    A backend_http_settings block supports the following:
    - name - (Required) The name of the Backend HTTP Settings Collection.
    - cookie_based_affinity - (Required) Is Cookie-Based Affinity enabled?
      Possible values are Enabled and Disabled.
    - port - (Required) The port which should be used for this Backend HTTP Settings Collection.
    - protocol - (Required) The Protocol which should be used.
      Possible values are Http and Https.
    - affinity_cookie_name - (Optional) The name of the affinity cookie.
    - path - (Optional) The Path which should be used as a prefix for all HTTP requests.
    - probe_name - (Optional) The name of an associated HTTP Probe.
    - request_timeout - (Optional) The request timeout in seconds, which must be between 1 and 86400 seconds.
      Defaults to 30.
    - host_name - (Optional) Host header to be sent to the backend servers.
      Cannot be set if pick_host_name_from_backend_address is set to true.
    - pick_host_name_from_backend_address - (Optional) Whether host header should be picked from the host name of the backend server.
      Defaults to false.
    - authentication_certificates - (Optional) One or more authentication_certificate blocks as defined below.
      A authentication_certificate block, within the backend_http_settings block supports the following:
      - name - (Required) The name of the Authentication Certificate.
    - trusted_root_certificate_names - (Optional) A list of trusted_root_certificate names.
    - connection_draining - (Optional) A connection_draining block as defined below.
      A connection_draining block supports the following:
      - enabled - (Required) If connection draining is enabled or not.
      - drain_timeout_sec - (Required) The number of seconds connection draining is active.
        Acceptable values are from 1 second to 3600 seconds.
  EOD
  type = map(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    probe_name                          = optional(string)
    request_timeout                     = optional(number)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    authentication_certificates = optional(map(object({
      name = string
    })), {})
    trusted_root_certificate_names = optional(list(string))
    connection_draining = optional(object({
      enabled           = bool
      drain_timeout_sec = number
    }))
  }))
}

variable "frontend_ip_configurations" {
  description = <<EOD
    (Required) (Required) One or more frontend_ip_configuration blocks as defined below.
    A frontend_ip_configuration block supports the following:
    - name - (Required) The name of the Frontend IP Configuration.
    - subnet_id - (Optional) The ID of the Subnet.
    - private_ip_address - (Optional) The Private IP Address to use for the Application Gateway.
    - public_ip_address_id - (Optional) The ID of a Public IP Address which the Application Gateway should use.
      The allocation method for the Public IP Address depends on the sku of this Application Gateway. Please refer to https://docs.microsoft.com/azure/virtual-network/public-ip-addresses#application-gateways for details.
    - private_ip_address_allocation - (Optional) The Allocation Method for the Private IP Address.
      Possible values are Dynamic and Static.
    - private_link_configuration_name - (Optional) The name of the private link configuration to use for this frontend IP configuration.
  EOD
  type = map(object({
    name                            = string
    subnet_id                       = optional(string)
    private_ip_address              = optional(string)
    public_ip_address_id            = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
  }))
}

variable "frontend_ports" {
  description = <<EOD
    (Required) One or more frontend_port blocks as defined below.
    A frontend_port block supports the following:
    - name - (Required) The name of the Frontend Port.
    - port - (Required) The port used for this Frontend Port.
  EOD
  type = map(object({
    name = string
    port = number
  }))
}

variable "gateway_ip_configurations" {
  description = <<EOD
    (Required) One or more gateway_ip_configuration blocks as defined below.
    A gateway_ip_configuration block supports the following:
    - name - (Required) The Name of this Gateway IP Configuration.
    - subnet_id - (Required) The ID of the Subnet which the Application Gateway should be connected to.
  EOD
  type = map(object({
    name      = string
    subnet_id = string
  }))
}

variable "http_listeners" {
  description = <<EOD
    (Required) One or more http_listener blocks as defined below.
    A http_listener block supports the following:
    - name - (Required) The Name of the HTTP Listener.
    - frontend_ip_configuration_name - (Required) The Name of the Frontend IP Configuration used for this HTTP Listener.
    - frontend_port_name - (Required) The Name of the Frontend Port use for this HTTP Listener.
    - host_name - (Optional) The Hostname which should be used for this HTTP Listener.
      Setting this value changes Listener Type to 'Multi site'.
    - host_names - (Optional) A list of Hostname(s) should be used for this HTTP Listener.
      It allows special wildcard characters.
    NOTE: The host_names and host_name are mutually exclusive and cannot both be set.
    - protocol - (Required) The Protocol to use for this HTTP Listener.
      Possible values are Http and Https.
    - require_sni - (Optional) Should Server Name Indication be Required?
      Defaults to false.
    - ssl_certificate_name - (Optional) The name of the associated SSL Certificate which should be used for this HTTP Listener.
    - custom_error_configurations - (Optional) One or more custom_error_configuration blocks as defined below.
      A custom_error_configuration block supports the following:
      - status_code - (Required) Status code of the application gateway customer error.
        Possible values are HttpStatus403 and HttpStatus502
      - custom_error_page_url - (Required) Error page URL of the application gateway customer error.
    - firewall_policy_id - (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTP Listener.
    - ssl_profile_name - (Optional) The name of the associated SSL Profile which should be used for this HTTP Listener.
  EOD
  type = map(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    protocol                       = string
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
    custom_error_configurations = map(object({
      status_code           = string
      custom_error_page_url = string
    }))
    firewall_policy_id = optional(string)
    ssl_profile_name   = optional(string)
  }))
}

variable "fips_enabled" {
  description = <<EOD
    (Optional) Is FIPS enabled on the Application Gateway?
  EOD
  default     = null
  type        = bool
}

variable "global" {
  description = <<EOD
    (Optional) A global block as defined below.
    A global block supports the following:
    - request_buffering_enabled - (Required) Whether Application Gateway's Request buffer is enabled.
    - response_buffering_enabled - (Required) Whether Application Gateway's Response buffer is enabled.
  EOD
  default     = null
  type = object({
    request_buffering_enabled  = bool
    response_buffering_enabled = bool
  })
}

variable "identity" {
  description = <<EOD
    (Optional) An identity block as defined below.
    An identity block supports the following:
    - type - (Required) Specifies the type of Managed Service Identity that should be configured on this Application Gateway.
      Only possible value is UserAssigned.
    - identity_ids - (Required) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Application Gateway.
  EOD
  default     = null
  type = object({
    type         = string
    identity_ids = list(string)
  })
}

variable "private_link_configurations" {
  description = <<EOD
    (Optional) One or more private_link_configuration blocks as defined below.
    A private_link_configuration block supports the following:
    - name - (Required) The name of the private link configuration.
    - ip_configurations - (Required) One or more ip_configuration blocks as defined below.
      An ip_configuration block supports the following:
      - name - (Required) The name of the IP configuration.
      - subnet_id - (Required) The ID of the subnet the private link configuration should connect to.
      - private_ip_address_allocation - (Required) The allocation method used for the Private IP Address.
        Possible values are Dynamic and Static.
      - primary - (Required) Is this the Primary IP Configuration?
      - private_ip_address - (Optional) The Static IP Address which should be used.
    NOTE: The AllowApplicationGatewayPrivateLink feature must be registered on the subscription before enabling private link with az feature register --name AllowApplicationGatewayPrivateLink --namespace Microsoft.Network
  EOD
  default     = {}
  type = map(object({
    name = string
    ip_configurations = map(object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      primary                       = bool
      private_ip_address            = optional(string)
    }))
  }))
}

variable "request_routing_rules" {
  description = <<EOD
    (Required) One or more request_routing_rule blocks as defined below.
    A request_routing_rule block supports the following:
    - name - (Required) The Name of this Request Routing Rule.
    - rule_type - (Required) The Type of Routing that should be used for this Rule.
      Possible values are Basic and PathBasedRouting.
    - http_listener_name - (Required) The Name of the HTTP Listener which should be used for this Routing Rule.
    - backend_address_pool_name - (Optional) The Name of the Backend Address Pool which should be used for this Routing Rule.
      Cannot be set if redirect_configuration_name is set.
    - backend_http_settings_name - (Optional) The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule.
      Cannot be set if redirect_configuration_name is set.
    - redirect_configuration_name - (Optional) The Name of the Redirect Configuration which should be used for this Routing Rule.
      Cannot be set if either backend_address_pool_name or backend_http_settings_name is set.
    - rewrite_rule_set_name - (Optional) The Name of the Rewrite Rule Set which should be used for this Routing Rule.
      Only valid for v2 SKUs.
    NOTE: backend_address_pool_name, backend_http_settings_name, redirect_configuration_name, and rewrite_rule_set_name are applicable only when rule_type is Basic.
    - url_path_map_name - (Optional) The Name of the URL Path Map which should be associated with this Routing Rule.
    - priority - (Optional) Rule evaluation order can be dictated by specifying an integer value from 1 to 20000 with 1 being the highest priority and 20000 being the lowest priority.
      NOTE: priority is required when sku.0.tier is set to *_v2.
  EOD
  type = map(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
    priority                    = optional(number)
  }))
}

variable "sku" {
  description = <<EOD
    (Required) A sku block as defined below.
    A sku block supports the following:
    - name - (Required) The Name of the SKU to use for this Application Gateway.
      Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2.
    - tier - (Required) The Tier of the SKU to use for this Application Gateway.
      Possible values are Standard, Standard_v2, WAF and WAF_v2.
    - capacity - (Optional) The Capacity of the SKU to use for this Application Gateway.
      When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU.
      This property is optional if autoscale_configuration is set.
  EOD
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "zones" {
  description = <<EOD
    (Optional) Specifies a list of Availability Zones in which this Application Gateway should be located.
    Changing this forces a new Application Gateway to be created.
    NOTE: Availability Zones are only supported in several regions at this time. They are also only supported for v2 SKUs.
  EOD
  default     = null
  type        = list(string)
}

variable "trusted_client_certificates" {
  description = <<EOD
    (Optional) One or more trusted_client_certificate blocks as defined below.
    A trusted_client_certificate block supports the following:
    - name - (Required) The name of the Trusted Client Certificate that is unique within this Application Gateway.
    - data - (Required) The base-64 encoded certificate.
  EOD
  default     = {}
  type = map(object({
    name = string
    data = string
  }))
}

variable "ssl_profiles" {
  description = <<EOD
    (Optional) One or more ssl_profile blocks as defined below.
    A ssl_profile block supports the following:
    - name - (Required) The name of the SSL Profile that is unique within this Application Gateway.
    - trusted_client_certificate_names - (Optional) The name of the Trusted Client Certificate that will be used to authenticate requests from clients.
    - verify_client_cert_issuer_dn - (Optional) Should client certificate issuer DN be verified?
      Defaults to false.
    - ssl_policy - (Optional) a ssl_policy block as defined below.
      A ssl_policy block supports the following:
      - disabled_protocols - (Optional) A list of SSL Protocols which should be disabled on this Application Gateway.
        Possible values are TLSv1_0, TLSv1_1, TLSv1_2 and TLSv1_3.
        NOTE: disabled_protocols cannot be set when policy_name or policy_type are set.
      - policy_type - (Optional) The Type of the Policy.
        Possible values are Predefined, Custom and CustomV2.
        NOTE: policy_type is Required when policy_name is set - cannot be set if disabled_protocols is set.
      When using a policy_type of Predefined the following fields are supported:
      - policy_name - (Optional) The Name of the Policy e.g AppGwSslPolicy20170401S.
        Required if policy_type is set to Predefined.
        Possible values can change over time and are published here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview.
        Not compatible with disabled_protocols.
      When using a policy_type of Custom the following fields are supported:
      - cipher_suites - (Optional) A List of accepted cipher suites.
        Possible values are: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256 and TLS_RSA_WITH_AES_256_GCM_SHA384.
      - min_protocol_version - (Optional) The minimal TLS version.
        Possible values are TLSv1_0, TLSv1_1, TLSv1_2 and TLSv1_3.
  EOD
  default     = {}
  type = map(object({
    name                             = string
    trusted_client_certificate_names = optional(list(string))
    verify_client_cert_issuer_dn     = optional(bool)
    ssl_policy = optional(object({
      disabled_protocols   = optional(list(string))
      policy_type          = optional(string)
      policy_name          = optional(string)
      cipher_suites        = optional(list(string))
      min_protocol_version = optional(string)
    }))
  }))
}

variable "authentication_certificates" {
  description = <<EOD
    (Optional) One or more authentication_certificate blocks as defined below.
    A authentication_certificate block supports the following:
    - name - (Required) The Name of the Authentication Certificate to use.
    - data - (Required) The contents of the Authentication Certificate which should be used.
  EOD
  default     = {}
  type = map(object({
    name = string
    data = string
  }))
}

variable "trusted_root_certificates" {
  description = <<EOD
    (Optional) One or more trusted_root_certificate blocks as defined below.
    A trusted_root_certificate block supports the following:
    - name - (Required) The Name of the Trusted Root Certificate to use.
    - data - (Optional) The contents of the Trusted Root Certificate which should be used.
      Required if key_vault_secret_id is not set.
    - key_vault_secret_id - (Optional) The Secret ID of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault.
      You need to enable soft delete for the Key Vault to use this feature.
      Required if data is not set.
      NOTE: TLS termination with Key Vault certificates is limited to the v2 SKUs.
      NOTE: For TLS termination with Key Vault certificates to work properly existing user-assigned managed identity, which Application Gateway uses to retrieve certificates from Key Vault, should be defined via identity block. Additionally, access policies in the Key Vault to allow the identity to be granted get access to the secret should be defined.
  EOD
  default     = {}
  type = map(object({
    name                = string
    data                = optional(string)
    key_vault_secret_id = optional(string)
  }))
}

variable "ssl_policy" {
  description = <<EOD
    (Optional) a ssl_policy block as defined below.
    A ssl_policy block supports the following:
      - disabled_protocols - (Optional) A list of SSL Protocols which should be disabled on this Application Gateway.
        Possible values are TLSv1_0, TLSv1_1, TLSv1_2 and TLSv1_3.
        NOTE: disabled_protocols cannot be set when policy_name or policy_type are set.
      - policy_type - (Optional) The Type of the Policy.
        Possible values are Predefined, Custom and CustomV2.
        NOTE: policy_type is Required when policy_name is set - cannot be set if disabled_protocols is set.
      When using a policy_type of Predefined the following fields are supported:
      - policy_name - (Optional) The Name of the Policy e.g AppGwSslPolicy20170401S.
        Required if policy_type is set to Predefined.
        Possible values can change over time and are published here https://docs.microsoft.com/azure/application-gateway/application-gateway-ssl-policy-overview.
        Not compatible with disabled_protocols.
      When using a policy_type of Custom the following fields are supported:
      - cipher_suites - (Optional) A List of accepted cipher suites.
        Possible values are: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA, TLS_DHE_DSS_WITH_AES_128_CBC_SHA256, TLS_DHE_DSS_WITH_AES_256_CBC_SHA, TLS_DHE_DSS_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA, TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, TLS_DHE_RSA_WITH_AES_256_CBC_SHA, TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_3DES_EDE_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA256, TLS_RSA_WITH_AES_128_GCM_SHA256, TLS_RSA_WITH_AES_256_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256 and TLS_RSA_WITH_AES_256_GCM_SHA384.
      - min_protocol_version - (Optional) The minimal TLS version.
        Possible values are TLSv1_0, TLSv1_1, TLSv1_2 and TLSv1_3.
  EOD
  default     = {}
  type = object({
    disabled_protocols   = optional(list(string))
    policy_type          = optional(string)
    policy_name          = optional(string)
    cipher_suites        = optional(list(string))
    min_protocol_version = optional(string)
  })
}

variable "enable_http2" {
  description = <<EOD
    (Optional) Is HTTP2 enabled on the application gateway resource?
    Defaults to false.
  EOD
  default     = null
  type        = bool
}

variable "force_firewall_policy_association" {
  description = <<EOD
    (Optional) Is the Firewall Policy associated with the Application Gateway?
  EOD
  default     = null
  type        = bool
}

variable "probes" {
  description = <<EOD
    (Optional) One or more probe blocks as defined below.
    A probe block support the following:
    - name - (Required) The Name of the Probe.
    - host - (Optional) The Hostname used for this Probe.
      If the Application Gateway is configured for a single site, by default the Host name should be specified as 127.0.0.1, unless otherwise configured in custom probe.
      Cannot be set if pick_host_name_from_backend_http_settings is set to true.
    - interval - (Required) The Interval between two consecutive probes in seconds.
      Possible values range from 1 second to a maximum of 86,400 seconds.
    - protocol - (Required) The Protocol used for this Probe.
      Possible values are Http and Https.
    - path - (Required) The Path used for this Probe.
    - timeout - (Required) The Timeout used for this Probe, which indicates when a probe becomes unhealthy.
      Possible values range from 1 second to a maximum of 86,400 seconds.
    - unhealthy_threshold - (Required) The Unhealthy Threshold for this Probe, which indicates the amount of retries which should be attempted before a node is deemed unhealthy.
      Possible values are from 1 to 20.
    - port - (Optional) Custom port which will be used for probing the backend servers.
      The valid value ranges from 1 to 65535.
      In case not set, port from HTTP settings will be used.
      This property is valid for Standard_v2 and WAF_v2 only.
    - pick_host_name_from_backend_http_settings - (Optional) Whether the host header should be picked from the backend HTTP settings.
      Defaults to false.
    - match - (Optional) A match block as defined.
      A match block supports the following:
      - body - (Optional) A snippet from the Response Body which must be present in the Response.
      - status_code - (Required) A list of allowed status codes for this Health Probe.
    - minimum_servers - (Optional) The minimum number of servers that are always marked as healthy.
      Defaults to 0.
  EOD
  default     = {}
  type = map(object({
    name                                      = string
    host                                      = optional(string)
    interval                                  = number
    protocol                                  = string
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = optional(number)
    pick_host_name_from_backend_http_settings = optional(bool)
    match = optional(object({
      body        = optional(string)
      status_code = list(string)
    }))
    minimum_servers = optional(number)
  }))
}

variable "ssl_certificates" {
  description = <<EOD
    (Optional) One or more ssl_certificate blocks as defined below.
    A ssl_certificate block supports the following:
    - name - (Required) The Name of the SSL certificate that is unique within this Application Gateway
    - data - (Optional) The base64-encoded PFX certificate data. Required if key_vault_secret_id is not set.
      NOTE: When specifying a file, use data = filebase64("path/to/file") to encode the contents of that file.
    - password - (Optional) Password for the pfx file specified in data. Required if data is set.
    - key_vault_secret_id - (Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault.
      You need to enable soft delete for keyvault to use this feature.
      Required if data is not set.
      NOTE: TLS termination with Key Vault certificates is limited to the v2 SKUs.
      NOTE: For TLS termination with Key Vault certificates to work properly existing user-assigned managed identity, which Application Gateway uses to retrieve certificates from Key Vault, should be defined via identity block. Additionally, access policies in the Key Vault to allow the identity to be granted get access to the secret should be defined.
  EOD
  default     = {}
  type = map(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}

variable "url_path_maps" {
  description = <<EOD
    (Optional) One or more url_path_map blocks as defined below.
    A url_path_map block supports the following:
    - name - (Required) The Name of the URL Path Map.
    - default_backend_address_pool_name - (Optional) The Name of the Default Backend Address Pool which should be used for this URL Path Map.
      Cannot be set if default_redirect_configuration_name is set.
    - default_backend_http_settings_name - (Optional) The Name of the Default Backend HTTP Settings Collection which should be used for this URL Path Map.
      Cannot be set if default_redirect_configuration_name is set.
    - default_redirect_configuration_name - (Optional) The Name of the Default Redirect Configuration which should be used for this URL Path Map.
      Cannot be set if either default_backend_address_pool_name or default_backend_http_settings_name is set.
    NOTE: Both default_backend_address_pool_name and default_backend_http_settings_name or default_redirect_configuration_name should be specified.
    - default_rewrite_rule_set_name - (Optional) The Name of the Default Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.
    - path_rules - (Required) One or more path_rule blocks as defined below.
      A path_rule block supports the following:
      - name - (Required) The Name of the Path Rule.
      - paths - (Required) A list of Paths used in this Path Rule.
      - backend_address_pool_name - (Optional) The Name of the Backend Address Pool to use for this Path Rule.
        Cannot be set if redirect_configuration_name is set.
      - backend_http_settings_name - (Optional) The Name of the Backend HTTP Settings Collection to use for this Path Rule.
        Cannot be set if redirect_configuration_name is set.
      - redirect_configuration_name - (Optional) The Name of a Redirect Configuration to use for this Path Rule.
        Cannot be set if backend_address_pool_name or backend_http_settings_name is set.
      - rewrite_rule_set_name - (Optional) The Name of the Rewrite Rule Set which should be used for this URL Path Map.
        Only valid for v2 SKUs.
      - firewall_policy_id - (Optional) The ID of the Web Application Firewall Policy which should be used as a HTTP Listener.
  EOD
  default     = {}
  type = map(object({
    name                                = string
    default_backend_address_pool_name   = optional(string)
    default_backend_http_settings_name  = optional(string)
    default_redirect_configuration_name = optional(string)
    default_rewrite_rule_set_name       = optional(string)
    path_rules = map(object({
      name                        = string
      paths                       = list(string)
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      firewall_policy_id          = optional(string)
    }))
  }))
}

variable "waf_configuration" {
  description = <<EOD
    (Optional) A waf_configuration block as defined below.
    A waf_configuration block supports the following:
    - enabled - (Required) Is the Web Application Firewall enabled?
    - firewall_mode - (Required) The Web Application Firewall Mode.
      Possible values are Detection and Prevention.
    - rule_set_type - (Optional) The Type of the Rule Set used for this Web Application Firewall.
      Possible values are OWASP and Microsoft_BotManagerRuleSet.
    - rule_set_version - (Required) The Version of the Rule Set used for this Web Application Firewall.
      Possible values are 0.1, 1.0, 2.2.9, 3.0, 3.1 and 3.2.
    - disabled_rule_groups - (Optional) one or more disabled_rule_group blocks as defined below.
      A disabled_rule_group block supports the following:
      - rule_group_name - (Required) The rule group where specific rules should be disabled.
        Possible values are BadBots, crs_20_protocol_violations, crs_21_protocol_anomalies, crs_23_request_limits, crs_30_http_policy, crs_35_bad_robots, crs_40_generic_attacks, crs_41_sql_injection_attacks, crs_41_xss_attacks, crs_42_tight_security, crs_45_trojans, General, GoodBots, Known-CVEs, REQUEST-911-METHOD-ENFORCEMENT, REQUEST-913-SCANNER-DETECTION, REQUEST-920-PROTOCOL-ENFORCEMENT, REQUEST-921-PROTOCOL-ATTACK, REQUEST-930-APPLICATION-ATTACK-LFI, REQUEST-931-APPLICATION-ATTACK-RFI, REQUEST-932-APPLICATION-ATTACK-RCE, REQUEST-933-APPLICATION-ATTACK-PHP, REQUEST-941-APPLICATION-ATTACK-XSS, REQUEST-942-APPLICATION-ATTACK-SQLI, REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION, REQUEST-944-APPLICATION-ATTACK-JAVA and UnknownBots.
      - rules - (Optional) A list of rules which should be disabled in that group.
        Disables all rules in the specified group if rules is not specified.
    - file_upload_limit_mb - (Optional) The File Upload Limit in MB.
      Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs.
      Defaults to 100MB.
    - request_body_check - (Optional) Is Request Body Inspection enabled?
      Defaults to true.
    - max_request_body_size_kb - (Optional) The Maximum Request Body Size in KB.
      Accepted values are in the range 1KB to 128KB.
      Defaults to 128KB.
    - exclusions - (Optional) one or more exclusion blocks as defined below.
      A exclusion block supports the following:
      - match_variable - (Required) Match variable of the exclusion rule to exclude header, cookie or GET arguments.
        Possible values are RequestArgKeys, RequestArgNames, RequestArgValues, RequestCookieKeys, RequestCookieNames, RequestCookieValues, RequestHeaderKeys, RequestHeaderNames and RequestHeaderValues
      - selector_match_operator - (Optional) Operator which will be used to search in the variable content.
        Possible values are Contains, EndsWith, Equals, EqualsAny and StartsWith.
        If empty will exclude all traffic on this match_variable
      - selector - (Optional) String value which will be used for the filter operation.
        If empty will exclude all traffic on this match_variable
  EOD
  default     = {}
  type = object({
    enabled          = optional(bool)
    firewall_mode    = optional(string)
    rule_set_type    = optional(string)
    rule_set_version = optional(string)
    disabled_rule_groups = optional(map(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    file_upload_limit_mb     = optional(string)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(string)
    exclusions = optional(object({
      match_variable          = string
      selector_match_operator = optional(string)
      selector                = optional(string)
    }))
  })
}

variable "custom_error_configurations" {
  description = <<EOD
    (Optional) One or more custom_error_configuration blocks as defined below.
    A custom_error_configuration block supports the following:
    - status_code - (Required) Status code of the application gateway customer error.
      Possible values are HttpStatus403 and HttpStatus502
    - custom_error_page_url - (Required) Error page URL of the application gateway customer error.
  EOD
  default     = {}
  type = map(object({
    status_code           = string
    custom_error_page_url = string
  }))
}

variable "firewall_policy_id" {
  description = <<EOD
    (Optional) The ID of the Web Application Firewall Policy.
  EOD
  default     = null
  type        = string
}

variable "redirect_configurations" {
  description = <<EOD
    (Optional) One or more redirect_configuration blocks as defined below.
    A redirect_configuration block supports the following:
    - name - (Required) Unique name of the redirect configuration block
    - redirect_type - (Required) The type of redirect.
      Possible values are Permanent, Temporary, Found and SeeOther
    - target_listener_name - (Optional) The name of the listener to redirect to.
      Cannot be set if target_url is set.
    - target_url - (Optional) The Url to redirect the request to.
      Cannot be set if target_listener_name is set.
    - include_path - (Optional) Whether or not to include the path in the redirected Url.
      Defaults to false
    - include_query_string - (Optional) Whether or not to include the query string in the redirected Url.
      Default to false
  EOD
  default     = {}
  type = map(object({
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string)
    target_url           = optional(string)
    include_path         = optional(bool)
    include_query_string = optional(bool)
  }))
}

variable "autoscale_configuration" {
  description = <<EOD
    (Optional) A autoscale_configuration block as defined below.
    A autoscale_configuration block supports the following:
    - min_capacity - (Required) Minimum capacity for autoscaling.
      Accepted values are in the range 0 to 100.
    - max_capacity - (Optional) Maximum capacity for autoscaling.
      Accepted values are in the range 2 to 125.
  EOD
  default     = {}
  type = object({
    min_capacity = number
    max_capacity = optional(number)
  })
}

variable "rewrite_rule_sets" {
  description = <<EOD
    (Optional) One or more rewrite_rule_set blocks as defined below.
    Only valid for v2 SKUs.
    A rewrite_rule_set block supports the following:
    - name - (Required) Unique name of the rewrite rule set block
    - rewrite_rules - (Optional) One or more rewrite_rule blocks as defined below.
      A rewrite_rule block supports the following:
      - name - (Required) Unique name of the rewrite rule block
      - rule_sequence - (Required) Rule sequence of the rewrite rule that determines the order of execution in a set.
      - conditions - (Optional) One or more condition blocks as defined below.
        A condition block supports the following:
        - variable - (Required) The variable of the condition.
        - pattern - (Required) The pattern, either fixed string or regular expression, that evaluates the truthfulness of the condition.
        - ignore_case - (Optional) Perform a case in-sensitive comparison.
          Defaults to false
        - negate - (Optional) Negate the result of the condition evaluation.
          Defaults to false
      - request_header_configurations - (Optional) One or more request_header_configuration blocks as defined below.
        A request_header_configuration block supports the following:
        - header_name - (Required) Header name of the header configuration.
        - header_value - (Required) Header value of the header configuration. To delete a request header set this property to an empty string.
      - response_header_configurations - (Optional) One or more response_header_configuration blocks as defined below.
        A response_header_configuration block supports the following:
        - header_name - (Required) Header name of the header configuration.
        - header_value - (Required) Header value of the header configuration.
          To delete a response header set this property to an empty string.
      - url - (Optional) One url block as defined below
        A url block supports the following:
        - path - (Optional) The URL path to rewrite.
        - query_string - (Optional) The query string to rewrite.
        - components - (Optional) The components used to rewrite the URL.
          Possible values are path_only and query_string_only to limit the rewrite to the URL Path or URL Query String only.
          NOTE: One or both of path and query_string must be specified. If one of these is not specified, it means the value will be empty. If you only want to rewrite path or query_string, use components.
        - reroute - (Optional) Whether the URL path map should be reevaluated after this rewrite has been applied. More info on rewrite configutation is at https://docs.microsoft.com/azure/application-gateway/rewrite-http-headers-url#rewrite-configuration
  EOD
  default     = {}
  type = map(object({
    name = string
    rewrite_rules = optional(map(object({
      name          = string
      rule_sequence = number
      conditions = optional(map(object({
        variable    = string
        pattern     = string
        ignore_case = optional(bool)
        negate      = optional(bool)
      })))
      request_header_configurations = optional(map(object({
        header_name  = string
        header_value = string
      })))
      response_header_configurations = optional(map(object({
        header_name  = string
        header_value = string
      })))
      url = optional(object({
        path         = optional(string)
        query_string = optional(string)
        components   = optional(string)
        reroute      = optional(bool)
      }))
    })))
  }))
}