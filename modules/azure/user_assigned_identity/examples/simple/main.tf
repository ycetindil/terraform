module "user_assigned_identity_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/user_assigned_identity"

  location            = var.user_assigned_identity_xxx.location
  name                = var.user_assigned_identity_xxx.name
  resource_group_name = module.resource_group_xxx.name
}