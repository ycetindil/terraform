variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Front Door Profile.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group where this Front Door Profile should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_name" {
  description = <<EOD
    (Required) Specifies the SKU for this Front Door Profile.
    Possible values include Standard_AzureFrontDoor and Premium_AzureFrontDoor.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "tags" {
  description = <<EOD
    (Optional) Specifies a mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}

variable "cdn_frontdoor_custom_domains" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_custom_domain subresource.
    A map of zero or more cdn_frontdoor_custom_domains supports the following:
    - name - (Required) The name which should be used for this Front Door Custom Domain.
      Possible values must be between 2 and 260 characters in length, must begin with a letter or number, end with a letter or number and contain only letters, numbers and hyphens.
      Changing this forces a new Front Door Custom Domain to be created.
    - host_name - (Required) The host name of the domain.
      The host_name field must be the FQDN of your domain (e.g. contoso.fabrikam.com).
      Changing this forces a new Front Door Custom Domain to be created.
    - dns_zone - (Optional) Reference to the existing Azure DNS Zone which should be used for this Front Door Custom Domain supports the following:
      If you are using Azure to host your DNS domains, you must delegate the domain provider's domain name system (DNS) to an Azure DNS Zone. For more information, see https://learn.microsoft.com/azure/dns/dns-delegate-domain-azure-dns.
      Otherwise, if you're using your own domain provider to handle your DNS, you must validate the Front Door Custom Domain by creating the DNS TXT records manually.
      - name - (Required) The Name of the DNS Zone.
      - resource_group_name - (Required) The Resource Group Name of the DNS Zone.
    - tls - (Required) A tls block supports the following:
      - certificate_type - (Optional) Defines the source of the SSL certificate.
        Possible values include CustomerCertificate and ManagedCertificate.
        Defaults to ManagedCertificate.
        NOTE: It may take up to 15 minutes for the Front Door Service to validate the state and Domain ownership of the Custom Domain.
      - minimum_tls_version - (Optional) TLS protocol version that will be used for Https.
        Possible values include TLS10 and TLS12.
        Defaults to TLS12.
      - cdn_frontdoor_secret - (Optional) Key of the Front Door Secret.
  EOD
  default     = {}
  type = map(object({
    name      = string
    host_name = string
    dns_zone = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    tls = object({
      certificate_type     = optional(string, null)
      minimum_tls_version  = optional(string, null)
      cdn_frontdoor_secret = optional(string, null)
    })
  }))
}

variable "cdn_frontdoor_endpoints" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_endpoint subresource.
    A map of zero or more cdn_frontdoor_endpoints supports the following:
    - name - (Required) The name which should be used for this Front Door Endpoint.
      Changing this forces a new Front Door Endpoint to be created.
    - cdn_frontdoor_profile_id - (Required) The ID of the Front Door Profile within which this Front Door Endpoint should exist.
      Provided by the module.
      Changing this forces a new Front Door Endpoint to be created.
    - tags - (Optional) Specifies a mapping of tags which should be assigned to the Front Door Endpoint.
  EOD
  default     = {}
  type = map(object({
    name = string
    tags = optional(map(string), null)
  }))
}

variable "cdn_frontdoor_origin_groups" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_origin_group subresource.
    A map of zero or more cdn_frontdoor_origin_groups supports the following:
    - name - (Required) The name which should be used for this Front Door Origin Group.
      Changing this forces a new Front Door Origin Group to be created.
    - cdn_frontdoor_profile_id - (Required) The ID of the Front Door Profile within which this Front Door Origin Group should exist.
      Provided by the module.
      Changing this forces a new Front Door Origin Group to be created.
    - load_balancing - (Required) A load_balancing block supports the following:
      - additional_latency_in_milliseconds - (Optional) Specifies the additional latency in milliseconds for probes to fall into the lowest latency bucket.
        Possible values are between 0 and 1000 milliseconds (inclusive).
        Defaults to 50.
      - sample_size - (Optional) Specifies the number of samples to consider for load balancing decisions.
        Possible values are between 0 and 255 (inclusive).
        Defaults to 4.
      - successful_samples_required - (Optional) Specifies the number of samples within the sample period that must succeed.
        Possible values are between 0 and 255 (inclusive).
        Defaults to 3.
    - health_probes - (Optional) A map of zero or more health_probe blocks supports the following:
      - protocol - (Required) Specifies the protocol to use for health probe.
        Possible values are Http and Https.
      - interval_in_seconds - (Required) Specifies the number of seconds between health probes.
        Possible values are between 5 and 31536000 seconds (inclusive).
      - request_type - (Optional) Specifies the type of health probe request that is made.
        Possible values are GET and HEAD.
        Defaults to HEAD.
      - path - (Optional) Specifies the path relative to the origin that is used to determine the health of the origin.
        Defaults to /.
        NOTE: Health probes can only be disabled if there is a single enabled origin in a single enabled origin group. For more information about the health_probe settings please see https://docs.microsoft.com/azure/frontdoor/health-probes.
    - restore_traffic_time_to_healed_or_new_endpoint_in_minutes - (Optional) Specifies the amount of time which should elapse before shifting traffic to another endpoint when a healthy endpoint becomes unhealthy or a new endpoint is added.
      Possible values are between 0 and 50 minutes (inclusive).
      Default is 10 minutes.
    - session_affinity_enabled - (Optional) Specifies whether session affinity should be enabled on this host.
      Defaults to true.
  EOD
  default     = {}
  type = map(object({
    name                                                      = string
    session_affinity_enabled                                  = optional(bool, null)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, null)
    load_balancing = object({
      additional_latency_in_milliseconds = optional(number, null)
      sample_size                        = optional(number, null)
      successful_samples_required        = optional(number, null)
    })
    health_probes = optional(map(object({
      protocol            = string
      interval_in_seconds = number
      request_type        = optional(string, null)
      path                = optional(string, null)
    })), {})
  }))
}

variable "cdn_frontdoor_origins" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_origin subresource.
    A map of zero or more cdn_frontdoor_origins supports the following:
    - name - (Required) The name which should be used for this Front Door Origin.
      Changing this forces a new Front Door Origin to be created.
    - cdn_frontdoor_origin_group - (Required) The key of the Front Door Origin Group within which this Front Door Origin should exist.
      Changing this forces a new Front Door Origin to be created.
    - host - (Required) The IPv4 address, IPv6 address or Domain name of the Origin.
      Provided by the module by taking below information:
      - name - (Required) The Name of the Host resource.
      - type - (Required) The Type of the Host resource.
        Possible values include Microsoft.Network/loadBalancers, Microsoft.Storage/blobs, and Microsoft.Web/sites.
      - resource_group_name - (Optional) The Name of the Resource Group of the Host resource. Required if type is Microsoft.Network/loadBalancers or Microsoft.Web/sites.
      - storage_account_name - (Optional) The Name of the Storage Account of the Host resource. Required if type is Microsoft.Storage/blobs.
      - storage_container_name - (Optional) The Name of the Storage Container of the Host resource. Required if type is Microsoft.Storage/blobs.
      IMPORTANT: This must be unique across all Front Door Origins within a Front Door Endpoint.
    - certificate_name_check_enabled - (Required) Specifies whether certificate name checks are enabled for this origin.
    - enabled - (Optional) Should the origin be enabled?
      Possible values are true or false.
      Defaults to true.
      NOTE: The enabled field will need to be explicitly set until the 4.0 provider is released due to the deprecation of the health_probes_enabled property in version 3.x of the AzureRM Provider.
    - http_port - (Optional) The value of the HTTP port.
      Must be between 1 and 65535.
      Defaults to 80.
    - https_port - (Optional) The value of the HTTPS port.
      Must be between 1 and 65535.
      Defaults to 443.
    - origin_host_header - (Optional) The host header value (an IPv4 address, IPv6 address or Domain name) which is sent to the origin with each request.
      If unspecified the hostname from the request will be used.
      NOTE: Azure Front Door Origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin's hostname. This field's value overrides the host header defined in the Front Door Endpoint. For more information on how to properly set the origin host header value please see https://docs.microsoft.com/azure/frontdoor/origin?pivots=front-door-standard-premium#origin-host-header.
    - priority - (Optional) Priority of origin in given origin group for load balancing.
      Higher priorities will not be used for load balancing if any lower priority origin is healthy.
      Must be between 1 and 5 (inclusive).
      Defaults to 1.
    - weight - (Optional) The weight of the origin in a given origin group for load balancing.
      Must be between 1 and 1000.
      Defaults to 500.
    - private_link - (Optional) A private_link block supports the following:
      - request_message - (Optional) Specifies the request message that will be submitted to the private_link_target_id when requesting the private link endpoint connection.
        Values must be between 1 and 140 characters in length.
        Defaults to Access request for CDN FrontDoor Private Link Origin.
      - location - (Required) Specifies the location where the Private Link resource should exist.
        Changing this forces a new resource to be created.
      - target - (Optional) Specifies the target for this Private Link Endpoint.
        Possible targets are blob, blob_secondary, web and sites.
      NOTE: Private Link requires that the Front Door Profile this Origin is hosted within is using the SKU Premium_AzureFrontDoor and that the certificate_name_check_enabled field is set to true.
      NOTE: At this time the Private Link Endpoint must be approved manually - for more information and region availability please see https://docs.microsoft.com/azure/frontdoor/private-link.
      IMPORTANT: Origin support for direct private end point connectivity is limited to Storage (Azure Blobs), App Services and internal load balancers. The Azure Front Door Private Link feature is region agnostic but for the best latency, you should always pick an Azure region closest to your origin when choosing to enable Azure Front Door Private Link endpoint.
      IMPORTANT: To associate a Load Balancer with a Front Door Origin via Private Link you must stand up your own azurerm_private_link_service - and ensure that a depends_on exists on the azurerm_cdn_frontdoor_origin resource to ensure it's destroyed before the azurerm_private_link_service resource (e.g. depends_on = [azurerm_private_link_service.example]) due to the design of the Front Door Service.
  EOD
  default     = {}
  type = map(object({
    name                       = string
    cdn_frontdoor_origin_group = string
    host = object({
      name                   = string
      type                   = string
      resource_group_name    = optional(string, null)
      storage_account_name   = optional(string, null)
      storage_container_name = optional(string, null)
    })
    certificate_name_check_enabled = bool
    enabled                        = optional(bool, null)
    http_port                      = optional(number, null)
    https_port                     = optional(number, null)
    origin_host_header             = optional(string, null)
    priority                       = optional(number, null)
    weight                         = optional(number, null)
    private_link = optional(object({
      request_message = optional(string, null)
      location        = string
      target = object({
        name                = string
        resource_group_name = string
      })
    }), null)
  }))
}

variable "cdn_frontdoor_routes" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_route subresource.
    A map of zero or more cdn_frontdoor_routes supports the following:
    - name - (Required) The name which should be used for this Front Door Route.
      Valid values must begin with a letter or number, end with a letter or number and may only contain letters, numbers and hyphens with a maximum length of 90 characters.
      Changing this forces a new Front Door Route to be created.
    - cdn_frontdoor_endpoint - (Required) The key of the Front Door Endpoint where this Front Door Route should exist.
      Changing this forces a new Front Door Route to be created.
    - cdn_frontdoor_origin_group - (Required) The key of the Front Door Origin Group where this Front Door Route should be created.
    - cdn_frontdoor_origins - (Required) One or more Front Door Origin keys that this Front Door Route will link to.
    - forwarding_protocol - (Optional) The Protocol that will be use when forwarding traffic to backends.
      Possible values are HttpOnly, HttpsOnly or MatchRequest.
    - patterns_to_match - (Required) The route patterns of the rule.
    - supported_protocols - (Required) One or more Protocols supported by this Front Door Route.
      Possible values are Http or Https.
      NOTE: If https_redirect_enabled is set to true the supported_protocols field must contain both Http and Https values.
    - cdn_frontdoor_custom_domains - (Optional) The keys of the Front Door Custom Domains which are associated with this Front Door Route.
    - cdn_frontdoor_origin_path - (Optional) A directory path on the Front Door Origin that can be used to retrieve content (e.g. contoso.cloudapp.net/originpath).
    - cdn_frontdoor_rule_sets - (Optional) A list of the Front Door Rule Set keys which should be assigned to this Front Door Route.
    - enabled - (Optional) Is this Front Door Route enabled?
      Possible values are true or false.
      Defaults to true.
    - https_redirect_enabled - (Optional) Automatically redirect HTTP traffic to HTTPS traffic?
      Possible values are true or false.
      Defaults to true.
      NOTE: The https_redirect_enabled rule is the first rule that will be executed.
    - link_to_default_domain - (Optional) Should this Front Door Route be linked to the default endpoint?
      Possible values include true or false.
      Defaults to true.
  EOD
  default     = {}
  type = map(object({
    name                         = string
    cdn_frontdoor_endpoint       = string
    cdn_frontdoor_origin_group   = string
    cdn_frontdoor_origins        = list(string)
    forwarding_protocol          = optional(string, null)
    patterns_to_match            = list(string)
    supported_protocols          = list(string)
    cdn_frontdoor_custom_domains = optional(list(string), null)
    cdn_frontdoor_origin_path    = optional(string, null)
    cdn_frontdoor_rule_sets      = optional(list(string), null)
    enabled                      = optional(bool, null)
    https_redirect_enabled       = optional(bool, null)
    link_to_default_domain       = optional(bool, null)
  }))
}

variable "cdn_frontdoor_rule_sets" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_rule_set subresource.
    A map of zero or more cdn_frontdoor_rule_sets supports the following:
    - name - (Required) The name which should be used for this Front Door Rule Set.
      Changing this forces a new Front Door Rule Set to be created.
    - cdn_frontdoor_profile_id - (Required) The ID of the Front Door Profile.
      Provided by the module.
      Changing this forces a new Front Door Rule Set to be created.
  EOD
  default     = {}
  type = map(object({
    name = string
  }))
}

variable "cdn_frontdoor_rules" {
  description = <<EOD
    (Optional) IMPORTANT: Created by azurerm_cdn_frontdoor_rule subresource.
    A map of zero or more cdn_frontdoor_rules supports the following:
    - name - (Required) The name which should be used for this Front Door Rule.
      Possible values must be between 1 and 260 characters in length, begin with a letter and may contain only letters and numbers.
      Changing this forces a new Front Door Rule to be created.
    - cdn_frontdoor_rule_set - (Required) The key of the Front Door Rule Set for this Front Door Rule.
      Changing this forces a new Front Door Rule to be created.
    - order - (Required) The order in which the rules will be applied for the Front Door Endpoint.
      The order value should be sequential and begin at 1(e.g. 1, 2, 3…).
      A Front Door Rule with a lesser order value will be applied before a rule with a greater order value.
      NOTE: If the Front Door Rule has an order value of 0 they do not require any conditions and the actions will always be applied.
      CAUTION: order is being generated inside the module and not given through a variable.
    - conditions - (Optional) A conditions block supports the following:
      NOTE: You may include up to 10 separate conditions in the conditions block.
      - request_scheme_condition - (Optional) A request_scheme_condition block supports the following:
        NOTE: The request_scheme_condition identifies requests that use the specified protocol.
        - operator - (Optional) Possible value Equal.
          Defaults to Equal.
        - negate_condition - (Optional) If true operator becomes the opposite of its value.
          Possible values true or false.
          Defaults to false.
        - match_values - (Optional) The requests protocol to match.
          Possible values include HTTP or HTTPS.
    - actions - (Required) An actions block supports the following:
      NOTE: You may include up to 5 separate actions in the actions block.
      NOTE: Some actions support Action Server Variables which provide access to structured information about the request. For more information about Action Server Variables see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule#action-server-variables.
      - url_redirect_action - (Optional) A url_redirect_action block supports the following:
        NOTE: You may not have a url_redirect_action and a url_rewrite_action defined in the same actions block.
        - redirect_type - (Required) The response type to return to the requestor.
          Possible values include Moved, Found, TemporaryRedirect or PermanentRedirect.
        - destination_hostname - (Required) The host name you want the request to be redirected to.
          The value must be a string between 0 and 2048 characters in length.
          Leave blank to preserve the incoming host.
        - redirect_protocol - (Optional) The protocol the request will be redirected as.
          Possible values include MatchRequest, Http or Https.
          Defaults to MatchRequest.
        - destination_path - (Optional) The path to use in the redirect.
          The value must be a string and include the leading /.
          Leave blank to preserve the incoming path.
          Defaults to an empty string, i.e. "".
        - query_string - (Optional) The query string used in the redirect URL.
          The value must be in the <key>=<value> or <key>={action_server_variable} format and must not include the leading ?.
          Leave blank to preserve the incoming query string.
          Maximum allowed length for this field is 2048 characters.
          Defaults to an empty string, i.e. "".
        - destination_fragment - (Optional) The fragment to use in the redirect.
          The value must be a string between 0 and 1024 characters in length
          Leave blank to preserve the incoming fragment.
          Defaults to an empty string, i.e. "".
  EOD
  default     = {}
  type = map(object({
    name                   = string
    cdn_frontdoor_rule_set = string
    conditions = optional(object({
      request_scheme_condition = optional(object({
        operator         = optional(string, null)
        negate_condition = optional(bool, null)
        match_values     = optional(list(string), null)
      }), null)
    }), null)
    actions = object({
      url_redirect_action = optional(object({
        redirect_type        = string
        destination_hostname = string
        redirect_protocol    = optional(string, null)
        destination_path     = optional(string, null)
        query_string         = optional(string, null)
        destination_fragment = optional(string, null)
      }), null)
    })
  }))
}