# Manages a LoadBalancer Probe Resource.
# NOTE: When using this resource, the Load Balancer needs to have a FrontEnd IP Configuration Attached
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe
resource "azurerm_lb_probe" "lb_probe" {
  name                = var.name
  loadbalancer_id     = var.loadbalancer_id
  protocol            = var.protocol
  port                = var.port
  probe_threshold     = var.probe_threshold
  request_path        = var.request_path
  interval_in_seconds = var.interval_in_seconds
  number_of_probes    = var.number_of_probes
}