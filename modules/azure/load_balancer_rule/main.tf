# Manages a Load Balancer Rule.
# NOTE: When using this resource, the Load Balancer needs to have a FrontEnd IP Configuration Attached
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = var.name
  loadbalancer_id                = var.loadbalancer_id
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  protocol                       = var.protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  backend_address_pool_ids       = var.backend_address_pool_ids
  probe_id                       = var.probe_id
  enable_floating_ip             = var.enable_floating_ip
  idle_timeout_in_minutes        = var.idle_timeout_in_minutes
  load_distribution              = var.load_distribution
  disable_outbound_snat          = var.disable_outbound_snat
  enable_tcp_reset               = var.enable_tcp_reset
}