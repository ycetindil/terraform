module "app_service_certificate_binding_xxx" {
  source = "./modules/app_service_certificate_binding"

  certificate_id      = module.app_service_certificate_xxx.id
  hostname_binding_id = module.app_service_custom_hostname_binding_xxx.id
  ssl_state           = var.app_service_certificate_binding_xxx.ssl_state
}