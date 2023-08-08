variable "name" {
  description = <<EOD
    (Required) The name of the Linux Virtual Machine.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The Azure location where the Linux Virtual Machine should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group in which the Linux Virtual Machine should be exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "size" {
  description = <<EOD
    (Required) The SKU which should be used for this Virtual Machine, such as Standard_F2.
  EOD
  type        = string
}

variable "admin_username" {
  description = <<EOD
    (Required) The username of the local administrator used for the Virtual Machine.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "admin_password" {
  description = <<EOD
    (Optional) The Password which should be used for the local-administrator on this Virtual Machine.
    Changing this forces a new resource to be created.
    NOTE: When an admin_password is specified disable_password_authentication must be set to false.
    NOTE: One of either admin_password or admin_ssh_key must be specified.
  EOD
  default     = null
  type        = string
}

variable "disable_password_authentication" {
  description = <<EOD
    (Optional) Should Password Authentication be disabled on this Virtual Machine?
    Defaults to true.
    Changing this forces a new resource to be created.
    NOTE: In general we'd recommend using SSH Keys for authentication rather than Passwords - but there's tradeoff's to each - please see https://security.stackexchange.com/questions/69407/why-is-using-an-ssh-key-more-secure-than-using-passwords for more information.
    NOTE: When an admin_password is specified disable_password_authentication must be set to false.
  EOD
  default     = null
  type        = bool
}

variable "custom_data" {
  description = <<EOD
    (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine.
    Changing this forces a new resource to be created.
  EOD
  default     = null
  type        = string
}

variable "network_interfaces" {
  description = <<EOD
    (Required). A list of Network Interface keys which should be attached to this Virtual Machine.
    The first Network Interface in this list will be the Primary Network Interface on the Virtual Machine.
  EOD
  type        = list(string)
}

variable "os_disk" {
  description = <<EOD
    (Required) A os_disk block as defined below.
    A os_disk block supports the following:
    - name - (Optional) The name which should be used for the Internal OS Disk.
      Changing this forces a new resource to be created.
    - caching - (Required) The Type of Caching which should be used for the Internal OS Disk.
      Possible values are None, ReadOnly and ReadWrite.
    - storage_account_type - (Required) The Type of Storage Account which should back this the Internal OS Disk.
      Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS.
      Changing this forces a new resource to be created.
  EOD
  type = object({
    name                 = optional(string, null)
    caching              = string
    storage_account_type = string
  })
}

variable "identity" {
  description = <<EOD
    (Optional) An identity block supports the following:
    - type - (Required) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine.
      Possible values are SystemAssigned, UserAssigned, "SystemAssigned, UserAssigned" (to enable both).
    - identity_ids - Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine.
      NOTE: This is required when type is set to UserAssigned or "SystemAssigned, UserAssigned".
  EOD
  default     = null
  type = object({
    type = string
    user_assigned_identities = optional(list(object({
      name                = string
      resource_group_name = string
    })), null)
  })
}

variable "admin_ssh_keys" {
  description = <<EOD
    (Optional) A map of zero or more admin_ssh_keys supports the following:
    - username - (Required) The Username for which this Public SSH Key should be configured.
      Changing this forces a new resource to be created.
    - public_key - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.
      Changing this forces a new resource to be created.
    NOTE: The Azure VM Agent only allows creating SSH Keys at the path /home/{username}/.ssh/authorized_keys - as such this public key will be written to the authorized keys file.
  EOD
  default     = {}
  type = map(object({
    username = string
    public_key = object({
      from_azure = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      from_local_computer = optional(object({
        path = string
      }), null)
    })
  }))
}

variable "source_image_reference" {
  description = <<EOD
    (Optional) A source_image_reference block as defined below.
    Changing this forces a new resource to be created.
    The source_image_reference block supports the following:
    - publisher - (Required) Specifies the publisher of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
    - offer - (Required) Specifies the offer of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
    - sku - (Required) Specifies the SKU of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
    - version - (Required) Specifies the version of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
  EOD
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "boot_diagnostics" {
  description = <<EOD
    (Optional) A boot_diagnostics block as defined below.
    A boot_diagnostics block supports the following:
    - storage_account_uri - (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.
    NOTE: Passing a null value will utilize a Managed Storage Account to store Boot Diagnostics
  EOD
  default     = null
  type = object({
    storage_uri = optional(string, null)
  })
}