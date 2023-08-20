# Manages a Linux Virtual Machine Scale Set.
# NOTE: As of the v2.86.0 (November 19, 2021) release of the provider this resource will only create Virtual Machine Scale Sets with the Uniform Orchestration Mode.
# NOTE: All arguments including the administrator login and password will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# NOTE: Terraform will automatically update & reimage the nodes in the Scale Set (if Required) during an Update - this behaviour can be configured using the features setting within the Provider block as described at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#features.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "linux_virtual_machine_scale_set" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_username      = var.admin_username
  instances           = var.instances
  sku                 = var.sku

  dynamic "network_interface" {
    for_each = var.network_interfaces

    content {
      name = network_interface.value.name

      dynamic "ip_configuration" {
        for_each = network_interface.value.ip_configurations

        content {
          name                                         = ip_configuration.value.name
          application_gateway_backend_address_pool_ids = ip_configuration.value.application_gateway_backend_address_pool_ids
          application_security_group_ids               = ip_configuration.value.application_security_group_ids
          load_balancer_backend_address_pool_ids       = ip_configuration.value.load_balancer_backend_address_pool_ids
          load_balancer_inbound_nat_rules_ids          = ip_configuration.value.load_balancer_inbound_nat_rules_ids
          primary                                      = ip_configuration.value.primary

          dynamic "public_ip_address" {
            for_each = ip_configuration.value.public_ip_address != null ? [1] : []

            content {
              name                    = ip_configuration.value.public_ip_address.name
              domain_name_label       = ip_configuration.value.public_ip_address.domain_name_label
              idle_timeout_in_minutes = ip_configuration.value.public_ip_address.idle_timeout_in_minutes

              dynamic "ip_tag" {
                for_each = ip_configuration.value.public_ip_address.ip_tags

                content {
                  tag  = ip_tag.value.tag
                  type = ip_tag.value.type
                }
              }

              public_ip_prefix_id = public_ip_address.value.public_ip_prefix_id
              version             = public_ip_address.value.version
            }
          }

          subnet_id = ip_configuration.value.subnet_id
          version   = ip_configuration.value.version
        }
      }

      dns_servers                   = network_interface.value.dns_servers
      enable_accelerated_networking = network_interface.value.enable_accelerated_networking
      enable_ip_forwarding          = network_interface.value.enable_ip_forwarding
      network_security_group_id     = network_interface.value.network_security_group_id
      primary                       = network_interface.value.primary
    }
  }

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type

    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings != null ? [1] : []

      content {
        option    = var.os_disk.diff_disk_settings.option
        placement = var.os_disk.diff_disk_settings.placement
      }
    }

    disk_encryption_set_id           = var.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.os_disk.disk_size_gb
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.os_disk.security_encryption_type
    write_accelerator_enabled        = var.os_disk.write_accelerator_enabled
  }

  admin_password = var.admin_password

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_keys

    content {
      public_key = admin_ssh_key.value.public_key
      username   = admin_ssh_key.value.username
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics != null ? [1] : []

    content {
      storage_account_uri = var.boot_diagnostics.storage_uri
    }
  }

  custom_data                     = var.custom_data
  disable_password_authentication = var.disable_password_authentication
  health_probe_id                 = var.health_probe_id

  dynamic "identity" {
    for_each = var.identity != null ? [1] : [0]

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = lower(var.upgrade_mode) == "rolling" ? [1] : []

    content {
      cross_zone_upgrades_enabled             = var.rolling_upgrade_policy.cross_zone_upgrades_enabled
      max_batch_instance_percent              = var.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.rolling_upgrade_policy.pause_time_between_batches
      prioritize_unhealthy_instances_enabled  = var.rolling_upgrade_policy.prioritize_unhealthy_instances_enabled
    }
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [1] : []

    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }

  tags         = var.tags
  upgrade_mode = var.upgrade_mode
}