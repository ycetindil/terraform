locals {
  # Gather all 'resource's from all 'backend_address_pool's.
  backend_address_pool_resources_flattened = flatten([
    for key, pool in var.backend_address_pools : [
      for k, resource in pool.resources :
      merge(resource, { backend_address_pool_key = key, resource_key = k })
    ]
  ])

  # Gather all 'network_interface' 'resource's from all 'backend_address_pool's.
  backend_address_pool_nic_resources = {
    for resource in local.backend_address_pool_resources_flattened :
    "${resource.backend_address_pool_key}_${resource.resource_key}" => resource
    if resource.type == "nic"
  }

  # Gather all 'virtual_machine_scale_set' 'resource's from all 'backend_address_pool's.
  backend_address_pool_vmss_resources = {
    for resource in local.backend_address_pool_resources_flattened :
    "${resource.backend_address_pool_key}_${resource.resource_key}" => resource
    if resource.type == "vmss"
  }

  # Gather all 'public_ip_address' 'resource's from all 'backend_address_pool's.
  backend_address_pool_pip_resources = {
    for resource in local.backend_address_pool_resources_flattened :
    "${resource.backend_address_pool_key}_${resource.resource_key}" => resource
    if resource.type == "pip"
  }

  # Gather all 'linux_web_app' 'resource's from all 'backend_address_pool's.
  backend_address_pool_lapp_resources = {
    for resource in local.backend_address_pool_resources_flattened :
    "${resource.backend_address_pool_key}_${resource.resource_key}" => resource
    if resource.type == "lapp"
  }

  # Gather all 'windows_web_app' 'resource's from all 'backend_address_pool's.
  backend_address_pool_wapp_resources = {
    for resource in local.backend_address_pool_resources_flattened :
    "${resource.backend_address_pool_key}_${resource.resource_key}" => resource
    if resource.type == "wapp"
  }

  # Gather all 'subnet's from all 'frontend_ip_configuration's.
  frontend_ip_configuration_subnets = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.subnet
    if configuration.subnet != null
  }

  # Gather all 'public_ip_address'es from all 'frontend_ip_configuration's.
  frontend_ip_configuration_public_ips = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.public_ip_address
    if configuration.public_ip_address != null
  }

  # Gather all 'subnet's from all 'gateway_ip_configuration's.
  gateway_ip_configuration_subnets = {
    for key, configuration in var.gateway_ip_configurations :
    key => configuration.subnet
  }

  # Gather all 'key_vault_secret's from all 'ssl_certificate's.
  ssl_certificate_key_vault_secrets = {
    for key, certificate in var.ssl_certificates :
    key => certificate.key_vault_secret
    if certificate.key_vault_secret != null
  }

  # Gather all 'firewall_policy's from all 'url_path_map's.
  url_path_map_firewall_policies_flattened = flatten([
    for key, path_map in var.url_path_maps : [
      for k, rule in path_map.path_rules :
      merge(rule.firewall_policy, { url_path_map_key = key, path_rule_key = k })
      if rule.firewall_policy != null
    ]
  ])

  url_path_map_firewall_policies = {
    for policy in local.url_path_map_firewall_policies_flattened :
    "${policy.url_path_map_key}_${policy.path_rule_key}" => policy
  }
}