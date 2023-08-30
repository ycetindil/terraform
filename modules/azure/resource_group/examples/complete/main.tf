module "resource_group_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/resource_group"

  name     = var.resource_group_xxx.name
  location = var.resource_group_xxx.location
}