module "service_plan_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/service_plan"

  name                = var.service_plan_xxx.name
  location            = var.service_plan_xxx.location
  resource_group_name = module.resource_group_xxx.name
  os_type             = var.service_plan_xxx.os_type
  sku_name            = var.service_plan_xxx.sku_name
}