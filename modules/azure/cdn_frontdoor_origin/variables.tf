variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Front Door Origin.
    Changing this forces a new Front Door Origin to be created.
  EOD
  type        = string
}

variable "cdn_frontdoor_origin_group_id" {
  description = <<EOD
    (Required) The ID of the Front Door Origin Group within which this Front Door Origin should exist.
    Changing this forces a new Front Door Origin to be created.
  EOD
  type        = string
}

variable "host_name" {
  description = <<EOD
    (Required) The IPv4 address, IPv6 address or Domain name of the Origin.
    IMPORTANT: This must be unique across all Front Door Origins within a Front Door Endpoint.
  EOD
  type        = string
}

variable "certificate_name_check_enabled" {
  description = <<EOD
    (Required) Specifies whether certificate name checks are enabled for this origin.
  EOD
  type        = bool
}

variable "enabled" {
  description = <<EOD
    (Optional) Should the origin be enabled?
    Possible values are true or false.
    Defaults to true.
    NOTE: The enabled field will need to be explicitly set until the 4.0 provider is released due to the deprecation of the health_probes_enabled property in version 3.x of the AzureRM Provider.
  EOD
  default     = null
  type        = bool
}

variable "http_port" {
  description = <<EOD
    (Optional) The value of the HTTP port.
    Must be between 1 and 65535.
    Defaults to 80.
  EOD
  default     = null
  type        = bool
}

variable "https_port" {
  description = <<EOD
    (Optional) The value of the HTTPS port.
    Must be between 1 and 65535.
    Defaults to 443.
  EOD
  default     = null
  type        = bool
}

variable "origin_host_header" {
  description = <<EOD
    (Optional) The host header value (an IPv4 address, IPv6 address or Domain name) which is sent to the origin with each request.
    If unspecified the hostname from the request will be used.
    NOTE: Azure Front Door Origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin's hostname. This field's value overrides the host header defined in the Front Door Endpoint. For more information on how to properly set the origin host header value please see https://docs.microsoft.com/azure/frontdoor/origin?pivots=front-door-standard-premium#origin-host-header.
  EOD
  default     = null
  type        = string
}

variable "priority" {
  description = <<EOD
    (Optional) Priority of origin in given origin group for load balancing.
    Higher priorities will not be used for load balancing if any lower priority origin is healthy.
    Must be between 1 and 5 (inclusive).
    Defaults to 1.
  EOD
  default     = null
  type        = bool
}

variable "private_link" {
  description = <<EOD
    (Optional) A private_link block as defined below.
    NOTE: Private Link requires that the Front Door Profile this Origin is hosted within is using the SKU Premium_AzureFrontDoor and that the certificate_name_check_enabled field is set to true.
    A private_link block supports the following:
    NOTE: At this time the Private Link Endpoint must be approved manually - for more information and region availability please see https://docs.microsoft.com/azure/frontdoor/private-link.
    IMPORTANT: Origin support for direct private end point connectivity is limited to Storage (Azure Blobs), App Services and internal load balancers. The Azure Front Door Private Link feature is region agnostic but for the best latency, you should always pick an Azure region closest to your origin when choosing to enable Azure Front Door Private Link endpoint.
    IMPORTANT: To associate a Load Balancer with a Front Door Origin via Private Link you must stand up your own azurerm_private_link_service - and ensure that a depends_on exists on the azurerm_cdn_frontdoor_origin resource to ensure it's destroyed before the azurerm_private_link_service resource (e.g. depends_on = [azurerm_private_link_service.example]) due to the design of the Front Door Service.
    - request_message - (Optional) Specifies the request message that will be submitted to the private_link_target_id when requesting the private link endpoint connection.
      Values must be between 1 and 140 characters in length.
      Defaults to Access request for CDN FrontDoor Private Link Origin.
    - target_type - (Optional) Specifies the type of target for this Private Link Endpoint.
      Possible values are blob, blob_secondary, web and sites.
      NOTE: target_type cannot be specified when using a Load Balancer as an Origin.
    - location - (Required) Specifies the location where the Private Link resource should exist.
      Changing this forces a new resource to be created.
    - private_link_target_id - (Required) The ID of the Azure Resource to connect to via the Private Link.
      Note: the private_link_target_id property must specify the Resource ID of the Private Link Service when using Load Balancer as an Origin.
  EOD
  default     = null
  type = object({
    request_message        = optional(string)
    target_type            = optional(string)
    location               = string
    private_link_target_id = string
  })
}

variable "weight" {
  description = <<EOD
    (Optional) The weight of the origin in a given origin group for load balancing.
    Must be between 1 and 1000.
    Defaults to 500.
  EOD
  default     = null
  type        = bool
}