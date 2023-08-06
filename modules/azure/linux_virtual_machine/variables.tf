variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  description = "Either authentication should be done with a password, or password authentication should be disabled."
  default     = null
  type        = string
}

variable "disable_password_authentication" {
  description = "Either authentication should be done with a password, or password authentication should be disabled."
  default     = null
  type        = bool
}

variable "custom_data_path" {
  default = null
  type    = string
}

variable "network_interfaces" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    ip_configurations = map(object({
      name = string
      subnet = object({
        name                       = string
        virtual_network_name       = string
        subnet_resource_group_name = string
      })
      private_ip_address_allocation = string
      public_ip_address = optional(object({
        existing = optional(object({
          name                = string
          resource_group_name = string
        }), null)
        new = optional(any, null) // Pass directly to the 'network_security_group' module
      }), null)
    }))
    network_security_group = optional(object({
      existing = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      new = optional(any, null) // Pass directly to the 'network_security_group' module
    }), null)
  }))
}

variable "identity" {
  default = null
  type = object({
    type = string
  })
}

variable "admin_ssh_keys" {
  default = {}
  type = map(object({
    username = string
    public_key = object({
      existing_on_azure = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      existing_on_local_computer = optional(object({
        path = string
      }), null)
    })
  }))
}

variable "os_disk" {
  type = object({
    name                 = optional(string)
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "boot_diagnostics" {
  default = null
  type = object({
    storage_uri = optional(string, null)
  })
}