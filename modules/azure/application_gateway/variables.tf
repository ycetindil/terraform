variable "name" {
  description = <<EOD
    (Required) The name of the Application Gateway.
    Changing this forces a new resource to be created
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

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to the Application Gateway should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku" {
  description = <<EOD
    (Required) A sku block supports the following:
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
    capacity = optional(number, null)
  })
}

variable "gateway_ip_configurations" {
  description = <<EOD
    (Required) A map of one or more gateway_ip_configuration blocks supports the following:
    - name - (Required) The Name of this Gateway IP Configuration.
    - subnet - (Required) The Subnet which the Application Gateway should be connected to.
  EOD
  type = map(object({
    name = string
    subnet = object({
      name                       = string
      virtual_network_name       = string
      subnet_resource_group_name = string
    })
  }))
}

variable "frontend_ports" {
  description = <<EOD
    (Required) A map of one or more frontend_port blocks supports the following:
    - name - (Required) The name of the Frontend Port.
    - port - (Required) The port used for this Frontend Port.
  EOD
  type = map(object({
    name = string
    port = number
  }))
}

variable "frontend_ip_configurations" {
  description = <<EOD
    (Required) A map of one or more frontend_ip_configuration blocks supports the following:
    - name - (Required) The name of the Frontend IP Configuration.
    - subnet - (Optional) The Subnet to use for the Application Gateway.
    - private_ip_address - (Optional) The Private IP Address to use for the Application Gateway.
    - public_ip_address - (Optional) The Public IP Address which the Application Gateway should use.
      The allocation method for the Public IP Address depends on the sku of this Application Gateway. Please refer to https://docs.microsoft.com/azure/virtual-network/public-ip-addresses#application-gateways for details.
    - private_ip_address_allocation - (Optional) The Allocation Method for the Private IP Address.
      Possible values are Dynamic and Static.
    - private_link_configuration_name - (Optional) The name of the private link configuration to use for this frontend IP configuration.
  EOD
  type = map(object({
    name = string
    subnet = optional(object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    }), null)
    private_ip_address = optional(string, null)
    public_ip_address = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    private_ip_address_allocation   = optional(string, null)
    private_link_configuration_name = optional(string, null)
  }))
}

variable "backend_address_pools" {
  description = <<EOT
    (Required) A map of one or more backend_address_pool blocks supports the following:
    - name - (Required) The name of the Backend Address Pool.
    - resources - (Optional) A map of resources supports the following:
      - type - (Required) - The type of the resource.
        Possible values are nic for network interface card, vmss for virtual machine scale set, pip for public IP address, ip for internal IP address, fqdn for fully qualified domain name, lapp for linux app service, and wapp for windows app service.
      - name - (Optional) The name of the resource.
        Required if resource type is one of: nic, vmss, lapp, or wapp.
      - resource_group_name - (Optional) The name of the resource group of the resource.
        Required if resource type is one of: nic, vmss, lapp, or wapp.
      - ip - (Optional) An IP as the resource.
        Required if resource type is one of: pip, or ip.
      - fqdn - (Optional) An FQDN as the resource.
        Required if resource type is fqdn.
  EOT
  type = map(object({
    name = string
    resources = optional(map(object({
      type                = string
      name                = optional(string)
      resource_group_name = optional(string)
      ip                  = optional(string)
      fqdn                = optional(string)
    })), {})
  }))
}

variable "backend_http_settingses" {
  description = <<EOD
    (Required) A map of one or more backend_http_settings blocks supports the following:
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
    - trusted_root_certificate_names - (Optional) A list of trusted_root_certificate names.
  EOD
  type = map(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    affinity_cookie_name                = optional(string, null)
    path                                = optional(string, null)
    probe_name                          = optional(string, null)
    request_timeout                     = optional(number, null)
    host_name                           = optional(string, null)
    pick_host_name_from_backend_address = optional(bool, null)
    trusted_root_certificate_names      = optional(list(string), null)
  }))
}

variable "probes" {
  description = <<EOD
    (Optional) A map of one or more probe blocks support the following:
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
    - minimum_servers - (Optional) The minimum number of servers that are always marked as healthy.
      Defaults to 0.
  EOD
  default     = {}
  type = map(object({
    name                                      = string
    host                                      = optional(string, null)
    interval                                  = number
    protocol                                  = string
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = optional(number, null)
    pick_host_name_from_backend_http_settings = optional(bool, null)
    minimum_servers                           = optional(number, null)
  }))
}

variable "http_listeners" {
  description = <<EOD
    (Required) A map of one or more http_listener blocks supports the following:
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
    - firewall_policy_id - (Optional) The ID of the Web Application Firewall Policy which should be used for this HTTP Listener.
    - ssl_profile_name - (Optional) The name of the associated SSL Profile which should be used for this HTTP Listener.
  EOD
  type = map(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    host_name                      = optional(string, null)
    host_names                     = optional(list(string), null)
    protocol                       = string
    require_sni                    = optional(bool, null)
    ssl_certificate_name           = optional(string, null)
    firewall_policy_id             = optional(string, null)
    ssl_profile_name               = optional(string, null)
  }))
}

variable "request_routing_rules" {
  description = <<EOD
    (Required) A map of one or more request_routing_rule blocks supports the following:
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
    backend_address_pool_name   = optional(string, null)
    backend_http_settings_name  = optional(string, null)
    redirect_configuration_name = optional(string, null)
    rewrite_rule_set_name       = optional(string, null)
    url_path_map_name           = optional(string, null)
    priority                    = optional(number, null)
  }))
}

variable "url_path_maps" {
  description = <<EOD
    (Optional) A map of one or more url_path_map blocks supports the following:
    - name - (Required) The Name of the URL Path Map.
    - default_backend_address_pool_name - (Optional) The Name of the Default Backend Address Pool which should be used for this URL Path Map.
      Cannot be set if default_redirect_configuration_name is set.
    - default_backend_http_settings_name - (Optional) The Name of the Default Backend HTTP Settings Collection which should be used for this URL Path Map.
      Cannot be set if default_redirect_configuration_name is set.
    - default_redirect_configuration_name - (Optional) The Name of the Default Redirect Configuration which should be used for this URL Path Map.
      Cannot be set if either default_backend_address_pool_name or default_backend_http_settings_name is set.
    NOTE: Both default_backend_address_pool_name and default_backend_http_settings_name or default_redirect_configuration_name should be specified.
    - default_rewrite_rule_set_name - (Optional) The Name of the Default Rewrite Rule Set which should be used for this URL Path Map. Only valid for v2 SKUs.
    - path_rules - (Required) A map of one or more path_rule blocks supports the following:
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