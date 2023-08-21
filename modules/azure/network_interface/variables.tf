variable "ip_configurations" {
  description = <<EOD
		(Required) One or more ip_configuration blocks as defined below.
    The ip_configuration block supports the following:
    - name - (Required) A name used for this IP Configuration.
    - gateway_load_balancer_frontend_ip_configuration_id - (Optional) The Frontend IP Configuration ID of a Gateway SKU Load Balancer.
    - subnet_id - (Optional) The ID of the Subnet where this Network Interface should be located in.
      NOTE: This is required when private_ip_address_version is set to IPv4.
    - private_ip_address_version - (Optional) The IP Version to use.
      Possible values are IPv4 or IPv6.
      Defaults to IPv4.
    - private_ip_address_allocation - (Required) The allocation method used for the Private IP Address.
      Possible values are Dynamic and Static.
      NOTE: Dynamic means "An IP is automatically assigned during creation of this Network Interface"; Static means "User supplied IP address will be used"
    - public_ip_address_id - (Optional) Reference to a Public IP Address to associate with this NIC.
    - primary - (Optional) Is this the Primary IP Configuration?
      Must be true for the first ip_configuration when multiple are specified.
      Defaults to false.
    - private_ip_address - (Optional) The Static IP Address which should be used.
      NOTE: This is required when private_ip_address_allocation is set to Static.
	EOD
  type = map(object({
    name                                               = string
    gateway_load_balancer_frontend_ip_configuration_id = optional(string)
    subnet_id                                          = optional(string)
    private_ip_address_version                         = optional(string)
    private_ip_address_allocation                      = string
    public_ip_address_id                               = optional(string)
    primary                                            = optional(bool)
    private_ip_address                                 = optional(string)
  }))
}

variable "location" {
  description = <<EOD
    (Required) The location where the Network Interface should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "name" {
  description = <<EOD
    (Required) The name of the Network Interface.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group in which to create the Network Interface.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "dns_servers" {
  description = <<EOD
    (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.
    NOTE: Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.
  EOD
  default     = null
  type        = list(string)
}

variable "edge_zone" {
  description = <<EOD
    (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist.
    Changing this forces a new Network Interface to be created.
  EOD
  default     = null
  type        = string
}

variable "enable_ip_forwarding" {
  description = <<EOD
    (Optional) Should IP Forwarding be enabled?
    Defaults to false.
  EOD
  default     = null
  type        = bool
}

variable "enable_accelerated_networking" {
  description = <<EOD
    (Optional) Should Accelerated Networking be enabled?
    Defaults to false.
    NOTE: Only certain Virtual Machine sizes are supported for Accelerated Networking - more information can be found at https://docs.microsoft.com/azure/virtual-network/create-vm-accelerated-networking-cli.
    NOTE: To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.
  EOD
  default     = null
  type        = bool
}

variable "internal_dns_name_label" {
  description = <<EOD
    (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.
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