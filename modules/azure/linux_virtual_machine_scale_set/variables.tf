variable "name" {
  description = <<EOD
    The name of the Linux Virtual Machine Scale Set.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "location" {
  description = <<EOD
    (Required) The Azure location where the Linux Virtual Machine Scale Set should exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "admin_username" {
  description = <<EOD
    (Required) The username of the local administrator on each Virtual Machine Scale Set instance.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}

variable "instances" {
  description = <<EOD
    (Optional) The number of Virtual Machines in the Scale Set.
    Defaults to 0.
    NOTE: If you are using AutoScaling, you may wish to use Terraform's ignore_changes functionality to ignore changes to this field.
  EOD
  default     = null
  type        = number
}

variable "sku" {
  description = <<EOD
    (Required) The Virtual Machine SKU for the Scale Set, such as Standard_F2.
  EOD
  type        = string
}

variable "network_interfaces" {
  description = <<EOD
    (Required) One or more network_interface blocks as defined below.
    A network_interface block supports the following:
    - name - (Required) The Name which should be used for this Network Interface.
      Changing this forces a new resource to be created.
    - ip_configurations - (Required) One or more ip_configuration blocks as defined below.
      An ip_configuration block supports the following:
      - name - (Required) The Name which should be used for this IP Configuration.
      - application_gateway_backend_address_pool_ids - (Optional) A list of Backend Address Pools ID's from a Application Gateway which this Virtual Machine Scale Set should be connected to.
        IMPORTANT: Procured by the module by collecting these existing application_gateway_backend_address_pool data:
        - name - (Required) The Name of the Backend Address Pool.
        - application_gateway - (Required) This block supports the following:
          - name - (Required) The Name of the Application Gateway of the Backend Address Pool.
          - resource_group_name - (Required) The Name of the Resource Group of the Application Gateway of the Backend Address Pool.
      - application_security_group_ids - (Optional) A list of Application Security Group ID's which this Virtual Machine Scale Set should be connected to.
        IMPORTANT: Procured by the module by collecting these existing application_security_group data:
        - name - (Required) The Name of the Application Security Group.
        - resource_group_name - (Required) The Name of the Resource Group of the Application Security Group.
      - load_balancer_backend_address_pool_ids - (Optional) A list of Backend Address Pools ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to.
        NOTE: When the Virtual Machine Scale Set is configured to have public IPs per instance are created with a load balancer, the SKU of the Virtual Machine instance IPs is determined by the SKU of the Virtual Machine Scale Sets Load Balancer (e.g. Basic or Standard). Alternatively, you may use the public_ip_prefix_id field to generate instance-level IPs in a virtual machine scale set as well. The zonal properties of the prefix will be passed to the Virtual Machine instance IPs, though they will not be shown in the output. To view the public IP addresses assigned to the Virtual Machine Scale Sets Virtual Machine instances use the az vmss list-instance-public-ips --resource-group ResourceGroupName --name VirtualMachineScaleSetName CLI command.
        NOTE: When using this field you'll also need to configure a Rule for the Load Balancer, and use a depends_on between this resource and the Load Balancer Rule.
        IMPORTANT: Procured by the module by collecting these existing load_balancer_backend_address_pool data:
        - name - (Required) The Name of the Backend Address Pool.
        - load_balancer - (Required) This block supports the following:
          - name - (Required) The Name of the Load Balancer of the Backend Address Pool.
          - resource_group_name - (Required) The Name of the Resource Group of the Load Balancer of the Backend Address Pool.
      - load_balancer_inbound_nat_rules_ids - (Optional) A list of NAT Rule ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to.
        NOTE: When using this field you'll also need to configure a Rule for the Load Balancer, and use a depends_on between this resource and the Load Balancer Rule.
      - primary - (Optional) Is this the Primary IP Configuration for this Network Interface?
        Defaults to false.
        NOTE: One ip_configuration block must be marked as Primary for each Network Interface.
      - public_ip_address - (Optional) A public_ip_address block as defined below.
        A public_ip_address block supports the following:
        - name - (Required) The Name of the Public IP Address Configuration.
        - domain_name_label - (Optional) The Prefix which should be used for the Domain Name Label for each Virtual Machine Instance.
          Azure concatenates the Domain Name Label and Virtual Machine Index to create a unique Domain Name Label for each Virtual Machine.
        - idle_timeout_in_minutes - (Optional) The Idle Timeout in Minutes for the Public IP Address.
          Possible values are in the range 4 to 32.
        - ip_tag - (Optional) One or more ip_tag blocks as defined below.
          Changing this forces a new resource to be created.
          An ip_tag block supports the following:
          - tag - (Required) The IP Tag associated with the Public IP, such as SQL or Storage.
            Changing this forces a new resource to be created.
          - type - (Required) The Type of IP Tag, such as FirstPartyUsage.
            Changing this forces a new resource to be created.
        - public_ip_prefix_id - (Optional) The ID of the Public IP Address Prefix from where Public IP Addresses should be allocated.
          Changing this forces a new resource to be created.
          NOTE: This functionality is in Preview and must be opted into via az feature register --namespace Microsoft.Network --name AllowBringYourOwnPublicIpAddress and then az provider register -n Microsoft.Network.
        - version - (Optional) The Internet Protocol Version which should be used for this public IP address.
          Possible values are IPv4 and IPv6. Defaults to IPv4.
          Changing this forces a new resource to be created.
      - subnet_id - (Optional) The ID of the Subnet which this IP Configuration should be connected to.
        NOTE: subnet_id is required if version is set to IPv4.
        IMPORTANT: Procured by the module by collecting these existing subnet data:
        - name - (Required) The Name of the Subnet.
        - virtual_network_name - (Required) The Name of the Virtual Network of the Subnet.
        - resource_group_name - (Required) The Name of the Resource Group of the Subnet.
      - version - (Optional) The Internet Protocol Version which should be used for this IP Configuration.
        Possible values are IPv4 and IPv6.
        Defaults to IPv4.
    - dns_servers - (Optional) A list of IP Addresses of DNS Servers which should be assigned to the Network Interface.
    - enable_accelerated_networking - (Optional) Does this Network Interface support Accelerated Networking?
      Defaults to false.
    - enable_ip_forwarding - (Optional) Does this Network Interface support IP Forwarding?
      Defaults to false.
    - network_security_group_id - (Optional) The ID of a Network Security Group which should be assigned to this Network Interface.
      IMPORTANT: Procured by the module by collecting these existing network_security_group data:
      - name - (Required) The Name of the Network Security Group.
      - resource_group_name - (Required) The Name of the Resource Group of the Network Security Group.
    - primary - (Optional) Is this the Primary IP Configuration?
      NOTE: If multiple network_interface blocks are specified, one must be set to primary.
  EOD
  type = map(object({
    name = string
    ip_configurations = map(object({
      name = string
      application_gateway_backend_address_pools = optional(map(object({
        name = string
        application_gateway = object({
          name                = string
          resource_group_name = string
        })
      })), null)
      application_security_groups = optional(map(object({
        name                = string
        resource_group_name = string
      })), null)
      load_balancer_backend_address_pools = optional(map(object({
        name = string
        load_balancer = object({
          name                = string
          resource_group_name = string
        })
      })), null)
      load_balancer_inbound_nat_rules_ids = optional(list(string), null)
      primary                             = optional(bool, null)
      public_ip_address = optional(object({
        name                    = string
        domain_name_label       = optional(string, null)
        idle_timeout_in_minutes = optional(number, null)
        ip_tags = optional(map(object({
          tag  = string
          type = string
        })), {})
        public_ip_prefix_id = optional(string, null)
        version             = optional(string, null)
      }), null)
      subnet = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      version = optional(string, null)
    }))
    dns_servers                   = optional(list(string), null)
    enable_accelerated_networking = optional(bool, null)
    enable_ip_forwarding          = optional(bool, null)
    network_security_group = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    primary = optional(bool, null)
  }))
}

variable "os_disk" {
  description = <<EOD
    (Required) An os_disk block as defined below.
    An os_disk block supports the following:
    - caching - (Required) The Type of Caching which should be used for the Internal OS Disk.
      Possible values are None, ReadOnly and ReadWrite.
    - storage_account_type - (Required) The Type of Storage Account which should back this the Internal OS Disk.
      Possible values include Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS and Premium_ZRS.
      Changing this forces a new resource to be created.
    - diff_disk_settings - (Optional) A diff_disk_settings block as defined above.
      Changing this forces a new resource to be created.
      A diff_disk_settings block supports the following:
      - option - (Required) Specifies the Ephemeral Disk Settings for the OS Disk.
        At this time the only possible value is Local.
        Changing this forces a new resource to be created.
      - placement - (Optional) Specifies where to store the Ephemeral Disk.
        Possible values are CacheDisk and ResourceDisk.
        Defaults to CacheDisk.
        Changing this forces a new resource to be created.
    - disk_encryption_set_id - (Optional) The ID of the Disk Encryption Set which should be used to encrypt this OS Disk.
      Conflicts with secure_vm_disk_encryption_set_id.
      Changing this forces a new resource to be created.
      NOTE: The Disk Encryption Set must have the Reader Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault
      NOTE: Disk Encryption Sets are in Public Preview in a limited set of regions
    - disk_size_gb - (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine Scale Set is sourced from.
      NOTE: If specified this must be equal to or larger than the size of the Image the VM Scale Set is based on. When creating a larger disk than exists in the image you'll need to repartition the disk to use the remaining space.
    - secure_vm_disk_encryption_set_id - (Optional) The ID of the Disk Encryption Set which should be used to Encrypt the OS Disk when the Virtual Machine Scale Set is Confidential VMSS.
      Conflicts with disk_encryption_set_id.
      Changing this forces a new resource to be created.
      NOTE: secure_vm_disk_encryption_set_id can only be specified when security_encryption_type is set to DiskWithVMGuestState.
    - security_encryption_type - (Optional) Encryption Type when the Virtual Machine Scale Set is Confidential VMSS.
      Possible values are VMGuestStateOnly and DiskWithVMGuestState.
      Changing this forces a new resource to be created.
      NOTE: vtpm_enabled must be set to true when security_encryption_type is specified.
      NOTE: encryption_at_host_enabled cannot be set to true when security_encryption_type is set to DiskWithVMGuestState.
    - write_accelerator_enabled - (Optional) Should Write Accelerator be Enabled for this OS Disk?
      Defaults to false.
      NOTE: This requires that the storage_account_type is set to Premium_LRS and that caching is set to None.
  EOD
  type = object({
    caching              = string
    storage_account_type = string
    diff_disk_settings = optional(object({
      option    = string
      placement = optional(string, null)
    }), null)
    disk_encryption_set_id           = optional(string, null)
    disk_size_gb                     = optional(number, null)
    secure_vm_disk_encryption_set_id = optional(string, null)
    security_encryption_type         = optional(string, null)
    write_accelerator_enabled        = optional(bool, null)
  })
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

variable "admin_ssh_keys" {
  description = <<EOD
    (Optional) One or more admin_ssh_key blocks as defined below.
    NOTE: One of either admin_password or admin_ssh_key must be specified.
    An admin_ssh_key block supports the following:
    - public_key - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.
    - username - (Required) The Username for which this Public SSH Key should be configured.
    NOTE: The Azure VM Agent only allows creating SSH Keys at the path /home/{username}/.ssh/authorized_keys - as such this public key will be added/appended to the authorized keys file.
  EOD
  default     = {}
  type = map(object({
    public_key = object({
      from_azure = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      from_local_computer = optional(object({
        path = string
      }), null)
    })
    username = string
  }))
}

variable "boot_diagnostics" {
  description = <<EOD
    (Optional) A boot_diagnostics block as defined below.
    A boot_diagnostics block supports the following:
    - storage_account_uri - (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.
    NOTE: Passing a null value will utilize a Managed Storage Account to store Boot Diagnostics.
  EOD
  default     = null
  type = object({
    storage_account_uri = optional(string, null)
  })
}

variable "custom_data" {
  description = <<EOD
    (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set.
    NOTE: When Custom Data has been configured, it's not possible to remove it without tainting the Virtual Machine Scale Set, due to a limitation of the Azure API.
  EOD
  default     = null
  type        = string
}

variable "disable_password_authentication" {
  description = <<EOD
    (Optional) Should Password Authentication be disabled on this Virtual Machine Scale Set?
    Defaults to true.
    NOTE: In general we'd recommend using SSH Keys for authentication rather than Passwords - but there's tradeoff's to each - please see https://security.stackexchange.com/questions/69407/why-is-using-an-ssh-key-more-secure-than-using-passwords for more information.
    NOTE: When a admin_password is specified disable_password_authentication must be set to false.
  EOD
  default     = null
  type        = bool
}

variable "identity" {
  description = <<EOD
    (Optional) An identity block as defined below.
    An identity block supports the following:
    - type - (Required) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine Scale Set.
      Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
    - identity_ids - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine Scale Set.
      NOTE: This is required when type is set to UserAssigned or "SystemAssigned, UserAssigned".
      IMPORTANT: Procured by the module by collecting these existing user_assigned_identities data:
      - name - (Required) The Name of the User Assigned Identity.
      - resource_group_name - (Required) The Name of the Resource Group of the User Assigned Identity.
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

variable "rolling_upgrade_policy" {
  description = <<EOD
    (Optional) A rolling_upgrade_policy block as defined below.
    This is Required and can only be specified when upgrade_mode is set to Automatic or Rolling.
    Changing this forces a new resource to be created.
    A rolling_upgrade_policy block supports the following:
    - cross_zone_upgrades_enabled - (Optional) Should the Virtual Machine Scale Set ignore the Azure Zone boundaries when constructing upgrade batches?
      Possible values are true or false.
    - max_batch_instance_percent - (Required) The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability.
    - max_unhealthy_instance_percent - (Required) The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.
    - max_unhealthy_upgraded_instance_percent - (Required) The maximum percentage of upgraded virtual machine instances that can be found to be in an unhealthy state. This check will happen after each batch is upgraded. If this percentage is ever exceeded, the rolling update aborts.
    - pause_time_between_batches - (Required) The wait time between completing the update for all virtual machines in one batch and starting the next batch.
      The time duration should be specified in ISO 8601 format.
    - prioritize_unhealthy_instances_enabled - (Optional) Upgrade all unhealthy instances in a scale set before any healthy instances.
      Possible values are true or false.
  EOD
  default     = null
  type = object({
    cross_zone_upgrades_enabled             = optional(bool, null)
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
    prioritize_unhealthy_instances_enabled  = optional(bool, null)
  })
}

variable "source_image" {
  description = <<EOD
    (Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on.
    Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs.
    NOTE: One of either source_image_id or source_image_reference must be set.
    - shared_image - (Optional) supports the following:
      - name - (Required) The name of the Shared Image.
      - gallery_name - (Required) The name of the Shared Image Gallery in which the Shared Image exists.
      - resource_group_name - (Required) The name of the Resource Group in which the Shared Image Gallery exists.
  EOD
  type = object({
    shared_image = optional(object({
      name                = string
      gallery_name        = string
      resource_group_name = string
    }))
  })
}

variable "source_image_reference" {
  description = <<EOD
    (Optional) A source_image_reference block as defined below.
    NOTE: One of either source_image_id or source_image_reference must be set.
    A source_image_reference block supports the following:
    - publisher - (Required) Specifies the publisher of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
    - offer - (Required) Specifies the offer of the image used to create the virtual machines.
      Changing this forces a new resource to be created.
    - sku - (Required) Specifies the SKU of the image used to create the virtual machines.
    - version - (Required) Specifies the version of the image used to create the virtual machines.
  EOD
  default     = null
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags which should be assigned to this Virtual Machine Scale Set.
  EOD
  default     = null
  type        = map(string)
}

variable "upgrade_mode" {
  description = <<EOD
    (Optional) Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances.
    Possible values are Automatic, Manual and Rolling.
    Defaults to Manual.
    Changing this forces a new resource to be created.
  EOD
  type        = string
}