module "log_analytics_workspace_xxx" {
  source = "./modules/log_analytics_workspace"

  name                = var.log_analytics_workspace_xxx.name
  location            = var.log_analytics_workspace_xxx.location
  resource_group_name = module.resource_group_xxx.name
}