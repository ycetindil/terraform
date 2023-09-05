module "afde_project102_prod_global_001" { // phonebook front door endpoint
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/cdn_frontdoor_endpoint"

  name                = var.afde_project102_prod_global_001.name
	cdn_frontdoor_profile_id = module.afd_project102_prod_global_001.id
}