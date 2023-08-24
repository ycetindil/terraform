locals {
  # Gather existing 'firewall_policy's from all the 'virtual_hub's
  existing_virtual_hub_firewall_policies = {
    for key, hub in var.virtual_hubs :
    key => hub.firewall.firewall_policy.existing
    if hub.firewall != null && hub.firewall.firewall_policy.existing != null
  }

  # Gather new 'firewall_policy's from all the 'virtual_hub's
  new_virtual_hub_firewall_policies = {
    for key, hub in var.virtual_hubs :
    key => hub.firewall.firewall_policy.new
    if hub.firewall != null && hub.firewall.firewall_policy.new != null
  }

  # Gather existing 'firewall's from all the 'virtual_hub's
  existing_virtual_hub_firewalls = {
    for key, hub in var.virtual_hubs :
    key => hub.firewall.existing
    if hub.firewall != null && hub.firewall.existing != null
  }

  # Gather new 'firewall's from all the 'virtual_hub's
  new_virtual_hub_firewalls = {
    for key, hub in var.virtual_hubs :
    key => hub.firewall.new
    if hub.firewall != null && hub.firewall.new != null
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'connection'.
  # Inject these into the 'connection' before flattening
  virtual_hub_connections_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, connection in virtual_hub.virtual_hub_connections :
        merge(connection, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have connections with the same name
  virtual_hub_connections = {
    for connection in local.virtual_hub_connections_flattened :
    "${connection.virtual_hub}_${connection.reference_name}" => connection
  }

  # Gather all the 'remote_virtual_network' onjects mentioned in the connections
  virtual_networks = {
    for key, connection in local.virtual_hub_connections :
    key => connection.remote_virtual_network
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'route_table.
  # Inject these into the 'connection' before flattening
  route_tables_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, route_table in virtual_hub.route_tables :
        merge(route_table, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have connections with the same name
  route_tables = {
    for route_table in local.route_tables_flattened :
    "${route_table.virtual_hub}_${route_table.reference_name}" => route_table
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'route_table_route'.
  # Inject these into the 'route' before flattening
  route_table_routes_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, route in virtual_hub.route_table_routes :
        merge(route, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have routes with the same name
  route_table_routes = {
    for route in local.route_table_routes_flattened :
    "${route.virtual_hub}_${route.reference_name}" => route
  }

  # Since same firewall can be referred by different routes, there may be duplicates
  # Use 'for loop' grouping
  route_table_route_firewalls = {
    for key, route in local.route_table_routes :
    key => route.next_hop.firewall...
  }
}

resource "azurerm_virtual_wan" "virtual_wan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_virtual_hub" "virtual_hubs" {
  for_each = var.virtual_hubs

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = var.address_prefix
}

# If 'firewall_policies' are existing, retrieve their data
data "azurerm_firewall_policy" "existing_virtual_hub_firewall_policies" {
  for_each = local.existing_virtual_hub_firewall_policies

  name                = var.name
  resource_group_name = var.resource_group_name
}

# If 'firewall_policies' are new, create them
module "new_virtual_hub_firewall_policies" {
  for_each = local.new_virtual_hub_firewall_policies
  source   = "../firewall_policy"

  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku                    = var.sku
  rule_collection_groups = try(var.rule_collection_groups)
}

# If 'firewalls' are existing, update them
resource "azapi_update_resource" "existing_virtual_hub_firewalls" {
  for_each = local.existing_virtual_hub_firewalls

  type      = "Microsoft.Network/azureFirewalls@2023-02-01"
  name      = var.name
  parent_id = var.resource_group_name

  body = jsonencode({
    properties = {
      virtualHub = azurerm_virtual_hub.virtual_hubs[each.key].id
    }
  })
}

# If 'firewalls' are new, create them
module "new_virtual_hub_firewalls" {
  source   = "../firewall"
  for_each = local.existing_virtual_hub_firewalls

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy = try(coalesce(
    data.azurerm_firewall_policy.existing_virtual_hub_firewall_policies[each.key],
    module.new_virtual_hub_firewall_policies[each.key]
  ), null)
  virtual_hub = {
    name                = azurerm_virtual_hub.virtual_hubs[each.key].name
    resource_group_name = azurerm_virtual_hub.virtual_hubs[each.key].resource_group_name
  }
}

data "azurerm_virtual_network" "virtual_networks" {
  for_each = local.virtual_networks

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_hub_connection" "virtual_hub_connections" {
  for_each = local.virtual_hub_connections

  name                      = var.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].id
  remote_virtual_network_id = data.azurerm_virtual_network.virtual_networks[each.key].id

  routing {
    associated_route_table_id = (
      var.routing.associated_route_table == "Default" ?
      azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id :
      (
        var.routing.associated_route_table == "None" ?
        replace(azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable") :
        azurerm_virtual_hub_route_table.virtual_hub_route_tables["${var.virtual_hub}_${var.reference_name}"].id
      )
    )
    propagated_route_table {
      route_table_ids = concat(
        [
          for route_table in var.routing.propagated_route_tables :
          azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id
          if route_table.name == "Default"
        ],
        [
          for route_table in var.routing.propagated_route_tables :
          replace(azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable")
          if route_table.name == "None"
        ],
        [
          for route_table in var.routing.propagated_route_tables :
          azurerm_virtual_hub_route_table.virtual_hub_route_tables["${route_table.virtual_hub}_${route_table.reference_name}"].id
          if route_table.name != "Default" && route_table.name != "None"
        ]
      )
    }
  }
}

# CYCLE ALERT! Letting the route tables create their own routes causes a cycle because
# the routes can refer to the connections and connections already refer to the route tables.
# Hence the 'rooute_table_routes' are created in the next block along with the 'Default table' routes.
resource "azurerm_virtual_hub_route_table" "virtual_hub_route_tables" {
  for_each = local.route_tables

  name           = var.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].id
}

# Below firewalls are not used to attach to the hub.
# They are the 'next_hop's of the 'route_table_routes'.
# Attaching firewalls to the hubs is done above.
data "azurerm_firewall" "route_table_route_firewalls" {
  for_each = local.route_table_route_firewalls

  # Since we used grouping, the value is a list of the same object multiple times
  # Therefore, we can use the very first one
  name                = var[0].name
  resource_group_name = var[0].resource_group_name

  depends_on = [module.new_virtual_hub_firewalls]
}

# Used for creating Default 'route_table' routes as well as custom 'route_table' routes
resource "azurerm_virtual_hub_route_table_route" "route_table_routes" {
  for_each = local.route_table_routes

  route_table_id = azurerm_virtual_hub.virtual_hubs[var.virtual_hub].default_route_table_id

  name              = var.name
  destinations_type = var.destinations_type
  destinations      = var.destinations
  next_hop_type     = var.next_hop_type
  # We need the connection's reference name rather than its name, hence the 'replace' function
  next_hop = (
    var.next_hop.firewall != {} ?
    data.azurerm_firewall.route_table_route_firewalls[each.key].id :
    azurerm_virtual_hub_connection.virtual_hub_connections["${var.virtual_hub}_${replace(var.next_hop.connection_name, "-", "_")}"].id
  )
}