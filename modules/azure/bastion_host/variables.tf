variable "name" {
  description = <<EOD
    (Required) Specifies the name of the Bastion Host.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the resource group in which to create the Bastion Host.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) Specifies the supported Azure location where the resource exists.
    Changing this forces a new resource to be created.
    Review https://learn.microsoft.com/en-us/azure/bastion/bastion-faq for supported locations.
  EOD
  type        = string
}

variable "ip_configuration" {
  description = <<EOD
    (Required) A ip_configuration block as defined below.
    Changing this forces a new resource to be created.
    A ip_configuration block supports the following:
    - name (required): The name of the IP configuration.
      Changing this forces a new resource to be created.
    - subnet_id - (Required) Reference to a subnet in which this Bastion Host has been created.
      Changing this forces a new resource to be created.
      NOTE: The Subnet used for the Bastion Host must have the name AzureBastionSubnet and the subnet mask must be at least a /26.
    - public_ip_address_id - (Required) Reference to a Public IP Address to associate with this Bastion Host.
      Changing this forces a new resource to be created.
  EOD
  type = object({
    name = string
    subnet_id = string
    public_ip_address_id = string
  })
}