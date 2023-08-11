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
    - subnet (required): Reference to an existing subnet in which this Bastion Host has been created supports the following:
      Changing this forces a new resource to be created.
      Note: The Subnet used for the Bastion Host must have the name AzureBastionSubnet and the subnet mask must be at least a /26.
      - name - (Required) The Name of the Subnet.
      - virtual_network_name - (Required) The Virtual Network Name of the Subnet.
      - resource_group_name - (Required) The Resource Group Name of the Subnet.
    - public_ip_address (required): Reference to an existing Public IP Address to associate with this Bastion Host supports the following:
      Changing this forces a new resource to be created.
      - name - (Required) The Name of the Public IP Address.
      - resource_group_name - (Required) The Resource Group Name of the Public IP Addres
  EOD
  type = object({
    name = string
    subnet = object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    })
    public_ip_address = object({
      name                = string
      resource_group_name = string
    })
  })
}