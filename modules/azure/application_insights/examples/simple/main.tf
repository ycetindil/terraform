module "application_insights_xxx" {
  source = "./modules/application_insights"

  name                = var.application_insights_xxx.name
  resource_group_name = module.resource_group_xxx.name
  location            = var.application_insights_xxx.location
  application_type    = var.application_insights_xxx.application_type
  workspace_id        = module.log_analytics_workspace_xxx.id
}