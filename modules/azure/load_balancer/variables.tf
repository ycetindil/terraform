variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Load Balancer.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group in which to create the Load Balancer.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) Specifies the supported Azure Region where the Load Balancer should be created.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "edge_zone" {
  description = <<EOD
    (Optional) Specifies the Edge Zone within the Azure Region where this Load Balancer should exist.
    Changing this forces a new Load Balancer to be created.
  EOD
  default     = null
  type        = string
}

variable "frontend_ip_configurations" {
  description = <<EOD
    (Optional) One or multiple frontend_ip_configuration blocks as documented below.
    The frontend_ip_configuration block supports the following:
    - name - (Required) Specifies the name of the frontend IP configuration.
    - zones - (Optional) Specifies a list of Availability Zones in which the IP Address for this Load Balancer should be located.
      NOTE: Availability Zones are only supported with a Standard SKU and in select regions at this time.
    - subnet_id - The ID of the Subnet which should be associated with the IP Configuration.
    - gateway_load_balancer_frontend_ip_configuration_id - (Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer.
    - private_ip_address - (Optional) Private IP Address to assign to the Load Balancer.
      The last one and first four IPs in any range are reserved and cannot be manually assigned.
    - private_ip_address_allocation - (Optional) The allocation method for the Private IP Address used by this Load Balancer.
      Possible values as Dynamic and Static.
    - private_ip_address_version - (Optional) The version of IP that the Private IP Address is.
      Possible values are IPv4 or IPv6.
    - public_ip_address_id - (Optional) The ID of a Public IP Address which should be associated with the Load Balancer.
    - public_ip_prefix_id - (Optional) The ID of a Public IP Prefix which should be associated with the Load Balancer.
      Public IP Prefix can only be used with outbound rules.
  EOD
  default     = {}
  type = map(object({
    name                          = string
    zones                         = optional(set(string))
    subnet_id                     = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string)
    private_ip_address_version    = optional(string)
    public_ip_address_id          = optional(string)
    public_ip_prefix_id           = optional(string)
  }))
}

variable "sku" {
  description = <<EOD
    (Optional) The SKU of the Azure Load Balancer.
    Accepted values are Basic, Standard and Gateway.
    Defaults to Basic.
    Changing this forces a new resource to be created.
    NOTE: The Microsoft.Network/AllowGatewayLoadBalancer feature is required to be registered in order to use the Gateway SKU. The feature can only be registered by the Azure service team, please submit an Azure support ticket for that at https://azure.microsoft.com/en-us/support/create-ticket/.
  EOD
  default     = null
  type        = string
}

variable "sku_tier" {
  description = <<EOD
    (Optional) The SKU tier of this Load Balancer.
    Possible values are Global and Regional.
    Defaults to Regional.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = string
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags to assign to the resource.
  EOD
  default     = null
  type        = map(string)
}