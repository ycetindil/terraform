module "afd_project102_prod_global_001" { // Phonebook Front Door Profile
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/cdn_frontdoor_profile"

  name                = var.afd_project102_prod_global_001.name
  resource_group_name = module.rg_project102_prod_global_001.name
  sku_name            = var.afd_project102_prod_global_001.sku_name
}