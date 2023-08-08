# Manages a Linux Virtual Machine.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
# NOTE: Terraform will automatically remove the OS Disk by default - this behaviour can be configured using the features setting within the Provider block.
# NOTE: All arguments including the administrator login and password will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# NOTE: This resource does not support Unmanaged Disks. If you need to use Unmanaged Disks you can continue to use the azurerm_virtual_machine resource instead.
# NOTE: This resource does not support attaching existing OS Disks. You can instead capture an image of the OS Disk or continue to use the azurerm_virtual_machine resource instead.
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  custom_data                     = var.custom_data
  network_interface_ids = [
    for key, interface in azurerm_network_interface.network_interfaces : interface.id
  ]

  os_disk {
    name                 = var.os_disk.name != null ? var.os_disk.name : "${var.name}-os-disk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  dynamic "identity" {
    for_each = var.identity != null ? [1] : [0]

    content {
      type         = var.identity.type
      identity_ids = try(data.azurerm_user_assigned_identity.user_assigned_identities[*].id, null)
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_keys

    content {
      username = var.admin_ssh_key.value.username
      public_key = try(
        data.azurerm_ssh_public_key.admin_ssh_keys_from_azure[admin_ssh_key.key].public_key,
        file(admin_ssh_key.value.public_key.from_local_computer.path),
        "'try' function could not find a valid 'public_key' for the 'admin_ssh_key' of the 'vm': ${var.name}!"
      )
    }
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics != null ? [1] : []

    content {
      storage_account_uri = var.boot_diagnostics.storage_uri
    }
  }
}

# Manages the association between a Network Interface and a Network Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  for_each = {
    for key, interface in var.network_interfaces : key => interface
    if interface.network_security_group != null
  }

  network_interface_id = azurerm_network_interface.network_interfaces[each.key].id
  network_security_group_id = try(
    data.azurerm_network_security_group.existing_network_security_groups[each.key].id,
    module.new_network_security_groups[each.key].id,
    "'try' function could not find a valid 'network_security_group_id' for the 'nic_nsg_association'!"
  )
}