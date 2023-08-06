locals {
  # Gather all 'load_balancer's from all origins
  load_balancers = {
    for key, origin in var.origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.private_link_service_enabled && origin.host.type == "Microsoft.Network/loadBalancers"
  }

  # Gather all 'private_link_service's from all origins
  private_link_services = {
    for key, origin in var.origins : key => {
      name                = origin.private_link.target.name
      resource_group_name = origin.private_link.target.resource_group_name
    }
    if origin.host.private_link_service_enabled && origin.host.type == "Microsoft.Network/loadBalancers"
  }

  # Gather all 'storage_blob's from all origins
  storage_blobs = {
    for key, origin in var.origins : key => {
      name                   = origin.host.name
      storage_account_name   = origin.host.storage_account_name
      storage_container_name = origin.host.storage_container_name
    }
    if origin.host.type == "Microsoft.Storage/blobs"
  }

  # Gather all 'app_service's from all origins
  app_services = {
    for key, origin in var.origins : key => {
      name                = origin.host.name
      resource_group_name = origin.host.resource_group_name
    }
    if origin.host.type == "Microsoft.Web/sites"
  }
}