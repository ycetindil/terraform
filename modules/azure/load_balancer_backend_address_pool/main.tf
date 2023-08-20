# Manages a Load Balancer Backend Address Pool.
# NOTE: When using this resource, the Load Balancer needs to have a FrontEnd IP Configuration Attached
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = var.name
  loadbalancer_id = var.loadbalancer_id

  dynamic "tunnel_interface" {
    for_each = var.tunnel_interfaces

    content {
      identifier = tunnel_interface.value.identifier
      type       = tunnel_interface.value.type
      protocol   = tunnel_interface.value.protocol
      port       = tunnel_interface.value.port
    }
  }

  virtual_network_id = var.virtual_network_id
}