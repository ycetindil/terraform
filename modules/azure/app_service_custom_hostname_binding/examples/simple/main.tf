module "app_service_custom_hostname_binding_xxx" {
  source = "./modules/app_service_custom_hostname_binding"

  hostname            = var.app_service_custom_hostname_binding_xxx.hostname
  app_service_name    = module.windows_web_app_xxx.name
  resource_group_name = module.resource_group_xxx.name

  depends_on = [module.dns_txt_record_xxx]
}