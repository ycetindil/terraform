locals {
  gateway_ip_configuration_existing_subnets = {
    for key, configuration in var.gateway_ip_configurations :
    key => configuration.subnet.existing
    if try(configuration.subnet.existing, null) != null
  }

  gateway_ip_configuration_new_subnets = {
    for key, configuration in var.gateway_ip_configurations :
    key => configuration.subnet.new
    if try(configuration.subnet.new, null) != null
  }

  frontend_ip_configuration_existing_subnets = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.subnet.existing
    if try(configuration.subnet.existing, null) != null
  }

  frontend_ip_configuration_new_subnets = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.subnet.new
    if try(configuration.subnet.new, null) != null
  }

  frontend_ip_configuration_existing_public_ips = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.public_ip_address.existing
    if try(configuration.public_ip_address.existing, null) != null
  }

  frontend_ip_configuration_new_public_ips = {
    for key, configuration in var.frontend_ip_configurations :
    key => configuration.public_ip_address.new
    if try(configuration.public_ip_address.new, null) != null
  }

  backend_address_pool_nic_resources = [
    for key, pool in var.backend_address_pools : {
      for k, resource in pool.resources :
      "${key}_${k}" => resource
      if resource.type == "nic"
    }
  ]

  backend_address_pool_vmss_resources = [
    for key, pool in var.backend_address_pools : {
      for k, resource in pool.resources :
      "${key}_${k}" => resource
      if resource.type == "vmss"
    }
  ]

  backend_address_pool_pip_resources = [
    for key, pool in var.backend_address_pools : {
      for k, resource in pool.resources :
      "${key}_${k}" => resource
      if resource.type == "pip"
    }
  ]

  backend_address_pool_lapp_resources = [
    for key, pool in var.backend_address_pools : {
      for k, resource in pool.resources :
      "${key}_${k}" => resource
      if resource.type == "lapp"
    }
  ]

  backend_address_pool_wapp_resources = [
    for key, pool in var.backend_address_pools : {
      for k, resource in pool.resources :
      "${key}_${k}" => resource
      if resource.type == "wapp"
    }
  ]
}