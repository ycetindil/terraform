locals {
  admin_ssh_keys_from_azure = {
    for key, ssh_key in var.admin_ssh_keys :
    key => ssh_key.public_key.from_azure
    if ssh_key.public_key.from_azure != null
  }

  network_interface_ip_configuration_subnets_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations : merge(configuration.subnet, { network_interface = key, ip_configuration = k })
    ]
  ])

  network_interface_ip_configuration_subnets = {
    for subnet in local.network_interface_ip_configuration_subnets_flattened :
    "${subnet.network_interface}_${subnet.ip_configuration}" => subnet
  }

  network_interface_ip_configuration_public_ip_addresses_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations :
      merge(configuration.public_ip_address.existing, { network_interface = key, ip_configuration = k })
      if try(configuration.public_ip_address.existing, null) != null
    ]
  ])

  network_interface_ip_configuration_public_ip_addresses = {
    for address in local.network_interface_ip_configuration_existing_public_ip_addresses_flattened :
    "${address.network_interface}_${address.ip_configuration}" => address
  }

  network_interface_network_security_groups = {
    for key, interface in var.network_interfaces :
    key => interface.network_security_group.existing
    if try(interface.network_security_group.existing, null) != null
  }
}