# Manages a Linux Virtual Machine.
# NOTE: Terraform will automatically remove the OS Disk by default - this behaviour can be configured using the features setting within the Provider block.
# NOTE: All arguments including the administrator login and password will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# NOTE: This resource does not support Unmanaged Disks. If you need to use Unmanaged Disks you can continue to use the azurerm_virtual_machine resource instead.
# NOTE: This resource does not support attaching existing OS Disks. You can instead capture an image of the OS Disk or continue to use the azurerm_virtual_machine resource instead.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_linux_virtual_machine" "vm" {
  admin_username = var.admin_username
  location       = var.location
  name           = var.name
  network_interface_ids = [
    for key, interface in var.network_interfaces :
    data.azurerm_network_interface.network_interfaces[key].id
  ]

  os_disk {
    name                 = var.os_disk.name != null ? var.os_disk.name : "${var.name}-os-disk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  resource_group_name = var.resource_group_name
  size                = var.size
  admin_password      = var.admin_password

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_keys

    content {
      username = var.admin_ssh_key.value.username
      public_key = try(
        data.azurerm_ssh_public_key.admin_ssh_keys_from_azure[admin_ssh_key.key].public_key,
        file(admin_ssh_key.value.public_key.from_local_computer.path),
        "'try' function could not find a valid 'public_key' for the 'admin_ssh_key': ${admin_ssh_key.key} of the 'vm': ${var.name}!"
      )
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

  dynamic "identity" {
    for_each = var.identity != null ? [1] : [0]

    content {
      type         = var.identity.type
      identity_ids = try(data.azurerm_user_assigned_identity.user_assigned_identities[*].id, null)
    }
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  tags = var.tags
}