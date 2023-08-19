variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Firewall.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the resource.
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

variable "sku_name" {
  description = <<EOD
    (Required) SKU name of the Firewall.
    Possible values are AZFW_Hub and AZFW_VNet.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "sku_tier" {
  description = <<EOD
    (Required) SKU tier of the Firewall.
    Possible values are Premium,Standard, and Basic.
  EOD
  type        = string
}

variable "firewall_policy_id" {
  description = <<EOD
    (Optional) The ID of the Firewall Policy applied to this Firewall.
  EOD
  default     = null
  type        = string
}

variable "ip_configuration" {
  description = <<EOD
    (Optional) An ip_configuration block as documented below.
    An ip_configuration block supports the following:
    - name - (Required) Specifies the name of the IP Configuration.
    - subnet_id - (Optional) Reference to the subnet associated with the IP Configuration.
      Changing this forces a new resource to be created.
      NOTE: The Subnet used for the Firewall must have the name AzureFirewallSubnet and the subnet mask must be at least a /26.
      NOTE: At least one and only one ip_configuration block may contain a subnet.
    - public_ip_address_id - (Optional) The ID of the Public IP Address associated with the firewall.
      NOTE: A public ip address is required unless a management_ip_configuration block is specified.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
      NOTE: When multiple ip_configuration blocks with public_ip_address are configured, terraform apply will raise an error when one or some of these ip_configuration blocks are removed. because the public_ip_address_id is still used by the firewall resource until the firewall resource is updated. and the destruction of azurerm_public_ip happens before the update of firewall by default. to destroy of azurerm_public_ip will cause the error. The workaround is to set create_before_destroy=true to the azurerm_public_ip resource lifecycle block. See more detail at https://github.com/hashicorp/terraform/blob/main/docs/destroying.md#create-before-destroy.
  EOD
  default     = null
  type = object({
    name                 = string
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
  })
}

variable "management_ip_configuration" {
  description = <<EOD
    (Optional) A management_ip_configuration block as documented below, which allows force-tunnelling of traffic to be performed by the firewall.
    Adding or removing this block or changing the subnet_id in an existing block forces a new resource to be created.
    Changing this forces a new resource to be created.
    A management_ip_configuration block supports the following:
    - name - (Required) Specifies the name of the IP Configuration.
    - subnet_id - (Required) Reference to the subnet associated with the IP Configuration.
      Changing this forces a new resource to be created.
      NOTE: The Management Subnet used for the Firewall must have the name AzureFirewallManagementSubnet and the subnet mask must be at least a /26.
    - public_ip_address_id - (Required) The ID of the Public IP Address associated with the firewall.
      NOTE: The Public IP must have a Static allocation and Standard SKU.
  EOD
  default     = null
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
}

variable "virtual_hub" {
  description = <<EOD
    (Optional) A virtual_hub block as documented below.
    A virtual_hub block supports the following:
    - virtual_hub_id - (Required) Specifies the ID of the Virtual Hub where the Firewall resides in.
    - public_ip_count - (Optional) Specifies the number of public IPs to assign to the Firewall.
      Defaults to 1.
  EOD
  default     = null
  type = object({
    virtual_hub_id  = string
    public_ip_count = number
  })
}