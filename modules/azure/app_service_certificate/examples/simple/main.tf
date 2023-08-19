module "app_service_certificate_xxx" {
  source = "./modules/app_service_certificate"

  name                = var.app_service_certificate_xxx.name
  resource_group_name = module.resource_group_xxx.name
  location            = var.app_service_certificate_xxx.location
  app_service_plan_id = module.service_plan_xxx.id
  key_vault_secret_id = data.azurerm_key_vault_certificate.key_vault_certificate_xxx_com.id

  depends_on = [module.key_vault_access_policy_xxx]
}