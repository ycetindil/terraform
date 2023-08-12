locals {
  admin_ssh_keys_from_azure = {
    for key, ssh_key in var.admin_ssh_keys :
    key => ssh_key.public_key.from_azure
    if ssh_key.public_key.from_azure != null
  }

  network_interface_network_security_groups = {
    for key, interface in var.network_interfaces :
    key => interface.network_security_group.existing
    if try(interface.network_security_group.existing, null) != null
  }
}