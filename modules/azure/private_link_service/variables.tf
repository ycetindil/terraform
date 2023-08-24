variable "name" {
  description = <<EOD
		(Required) Specifies the name of this Private Link Service.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the Resource Group where the Private Link Service should exist.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "location" {
  description = <<EOD
		(Required) Specifies the supported Azure location where the resource exists.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "nat_ip_configuration" {
  description = <<EOD
		(Required) One or more (up to 8) nat_ip_configuration block as defined below.
		The nat_ip_configuration block supports the following:
		- name - (Required) Specifies the name which should be used for the NAT IP Configuration.
			Changing this forces a new resource to be created.
		- subnet_id - (Required) Specifies the ID of the Subnet which should be used for the Private Link Service.
			NOTE: Verify that the Subnet's enforce_private_link_service_network_policies attribute is set to true.
		- primary - (Required) Is this is the Primary IP Configuration?
			Changing this forces a new resource to be created.
		-	private_ip_address - (Optional) Specifies a Private Static IP Address for this IP Configuration.
		-	private_ip_address_version - (Optional) The version of the IP Protocol which should be used.
			At this time the only supported value is IPv4.
			Defaults to IPv4.
	EOD
  type = map(object({
    name                       = string
    subnet_id                  = string
    primary                    = bool
    private_ip_address         = optional(string)
    private_ip_address_version = optional(string)
  }))
}

variable "load_balancer_frontend_ip_configuration_ids" {
  description = <<EOD
		(Required) A list of Frontend IP Configuration IDs from a Standard Load Balancer, where traffic from the Private Link Service should be routed.
		You can use Load Balancer Rules to direct this traffic to appropriate backend pools where your applications are running.
		Changing this forces a new resource to be created.
	EOD
  type        = set(string)
}

variable "auto_approval_subscription_ids" {
  description = <<EOD
		(Optional) A list of Subscription UUID/GUID's that will be automatically be able to use this Private Link Service.
	EOD
  default     = null
  type        = set(string)
}

variable "enable_proxy_protocol" {
  description = <<EOD
		(Optional) Should the Private Link Service support the Proxy Protocol?
	EOD
  default     = null
  type        = bool
}

variable "fqdns" {
  description = <<EOD
		(Optional) List of FQDNs allowed for the Private Link Service.
	EOD
  default     = null
  type        = list(string)
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags to assign to the resource.
	EOD
  default     = null
  type        = map(string)
}

variable "visibility_subscription_ids" {
  description = <<EOD
		(Optional) A list of Subscription UUID/GUID's that will be able to see this Private Link Service.
		NOTE: If no Subscription IDs are specified then Azure allows every Subscription to see this Private Link Service.
	EOD
  default     = null
  type        = set(string)
}