locals {
  # Gather all 'application_gateway's from all 'ip_configuration's of all 'network_interface's.
  # Preserve 'network_interface_key' and 'ip_configuration_key' for they will be lost after flattening.
  network_interface_ip_configuration_application_gateways_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations : [
        for l, pool in configuration.application_gateway_backend_address_pools :
        merge(pool.application_gateway, { network_interface_key = key, ip_configuration_key = k })
        if configuration.application_gateway_backend_address_pools != null
      ]
    ]
  ])

  # Convert the flattened list to a map.
  network_interface_ip_configuration_application_gateways = {
    for gateway in network_interface_ip_configuration_application_gateways_flattened :
    "${gateway.network_interface_key}_${gateway.ip_configuration_key}" => gateway
  }

  # Gather all 'application_security_group's from all 'ip_configuration's of all 'network_interface's.
  # Preserve 'network_interface_key' and 'ip_configuration_key' for they will be lost after flattening.
  network_interface_ip_configuration_application_security_groups_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations : [
        for l, group in configuration.application_security_groups :
        merge(group, { network_interface_key = key, ip_configuration_key = k })
        if configuration.application_security_groups != null
      ]
    ]
  ])

  # Convert the flattened list to a map.
  network_interface_ip_configuration_application_security_groups = {
    for group in network_interface_ip_configuration_application_security_groups_flattened :
    "${gateway.network_interface_key}_${gateway.ip_configuration_key}" => group
  }

  # Gather all 'load_balancer_backend_address_pool's from all 'ip_configuration's of all 'network_interface's.
  # Preserve 'network_interface_key' and 'ip_configuration_key' for they will be lost after flattening.
  network_interface_ip_configuration_load_balancer_backend_address_pools_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations : [
        for l, pool in configuration.load_balancer_backend_address_pools :
        merge(pool, { network_interface_key = key, ip_configuration_key = k })
        if configuration.load_balancer_backend_address_pools != null
      ]
    ]
  ])

  # Convert the flattened list to a map.
  network_interface_ip_configuration_load_balancer_backend_address_pools = {
    for pool in network_interface_ip_configuration_load_balancer_backend_address_pools_flattened :
    "${pool.network_interface_key}_${pool.ip_configuration_key}" => pool
  }

  # Gather all 'subnet's from all 'ip_configuration's of all 'network_interface's.
  # Preserve 'network_interface_key' and 'ip_configuration_key' for they will be lost after flattening.
  network_interface_ip_configuration_subnets_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations :
      merge(configuration.subnet, { network_interface_key = key, ip_configuration_key = k })
      if configuration.subnet != null
    ]
  ])

  # Convert the flattened list to a map.
  network_interface_ip_configuration_subnets = {
    for subnet in network_interface_ip_configuration_subnets_flattened :
    "${subnet.network_interface_key}_${subnet.ip_configuration_key}" => subnet
  }

  # Gather all 'network_security_group's from all 'network_interface's.
  network_interface_network_security_groups = {
    for key, interface in var.network_interfaces : key => interface.network_security_group
    if interface.network_security_group != null
  }

  # Gather all 'admin_ssh_key's from Azure
  admin_ssh_keys_from_azure = {
    for key, ssh_key in var.admin_ssh_keys :
    key => ssh_key.public_key.from_azure
    if ssh_key.public_key.from_azure != null
  }
}