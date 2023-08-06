data "azurerm_ssh_public_key" "admin_ssh_keys" {
  for_each = {
    for key, ssh_key in var.admin_ssh_keys :
    key => ssh_key.public_key.existing_on_azure
    if ssh_key.public_key.existing_on_azure != null
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

locals {
  network_interface_ip_configuration_subnets_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations : merge(configuration.subnet, { network_interface = key, ip_configuration = k })
    ]
  ])

  network_interface_ip_configuration_subnets = {
    for subnet in local.network_interface_ip_configuration_subnets_flattened :
    "${subnet.network_interface}_${subnet.ip_configuration}" => subnet
  }

  network_interface_ip_configuration_existing_public_ip_addresses_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations :
      merge(configuration.public_ip_address.existing, { network_interface = key, ip_configuration = k })
      if try(configuration.public_ip_address.existing, null) != null
    ]
  ])

  network_interface_ip_configuration_existing_public_ip_addresses = {
    for address in local.network_interface_ip_configuration_existing_public_ip_addresses_flattened :
    "${address.network_interface}_${address.ip_configuration}" => address
  }

  network_interface_ip_configuration_new_public_ip_addresses_flattened = flatten([
    for key, interface in var.network_interfaces : [
      for k, configuration in interface.ip_configurations :
      merge(configuration.public_ip_address.new, { network_interface = key, ip_configuration = k })
      if try(configuration.public_ip_address.new, null) != null
    ]
  ])

  network_interface_ip_configuration_new_public_ip_addresses = {
    for address in local.network_interface_ip_configuration_new_public_ip_addresses_flattened :
    "${address.network_interface}_${address.ip_configuration}" => address
  }
}

data "azurerm_subnet" "subnets" {
  for_each = local.network_interface_ip_configuration_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.subnet_resource_group_name
}

data "azurerm_public_ip" "existing_public_ip_addresses" {
  for_each = local.network_interface_ip_configuration_existing_public_ip_addresses

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

module "new_public_ip_addresses" {
  for_each = local.network_interface_ip_configuration_new_public_ip_addresses
  source   = "../public_ip_address"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

resource "azurerm_network_interface" "network_interfaces" {
  for_each = var.network_interfaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnets["${each.key}_${ip_configuration.key}"].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      # If none of 'existing' or 'new' 'public_ip_address' is given, 'coalesce' will throw an error. 'Try' will catch it and return 'null'.
      public_ip_address_id = try(coalesce(
        try(data.azurerm_public_ip.existing_public_ip_addresses["${each.key}_${ip_configuration.key}"].id, ""),
        try(module.new_public_ip_addresses["${each.key}_${ip_configuration.key}"].id, "")
      ), null)
    }
  }
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  custom_data                     = var.custom_data_path
  network_interface_ids = [
    for key, interface in azurerm_network_interface.network_interfaces : interface.id
  ]

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type = var.identity.type
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_keys

    content {
      username = var.admin_ssh_key.value.username
      public_key = try(
        data.azurerm_ssh_public_key.admin_ssh_keys[admin_ssh_key.key].public_key,
        file(admin_ssh_key.value.public_key.existing_on_local_computer.path),
        "'Try' could not find any valid 'public_key'"
      )
    }
  }

  os_disk {
    name                 = var.os_disk.name != null ? var.os_disk.name : "${var.name}-os-disk"
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
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

data "azurerm_network_security_group" "existing_network_security_groups" {
  for_each = {
    for key, interface in var.network_interfaces :
    key => interface.network_security_group.existing
    if try(interface.network_security_group.existing, null) != null
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

module "new_network_security_groups" {
  for_each = {
    for key, interface in var.network_interfaces :
    key => interface.network_security_group.new
    if try(interface.network_security_group.new, null) != null
  }
  source = "../network_security_group"

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  security_rules      = each.value.security_rules
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  for_each = {
    for key, interface in var.network_interfaces : key => interface
    if interface.network_security_group != null
  }

  network_interface_id = azurerm_network_interface.network_interfaces[each.key].id
  network_security_group_id = coalesce(
    try(data.azurerm_network_security_group.existing_network_security_groups[each.key].id, ""),
    try(module.new_network_security_groups[each.key].id, ""),
    "Coalesce could not find a valid 'network_security_group_id'"
  )
}