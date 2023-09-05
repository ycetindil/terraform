module "afdo_project102_prod_global_001" { // west europe ilb
	source = "github.com/ycetindil/terraform/tree/main/modules/azure/cdn_frontdoor_origin"

	name                           = var.afdo_project102_prod_global_001.name
	cdn_frontdoor_origin_group     = module.afdog_project102_prod_global_001.name
	host_name = module.lb_project102_prod_westeurope_001.name
	certificate_name_check_enabled = var.afdo_project102_prod_global_001.certificate_name_check_enabled
	enabled                        = var.afdo_project102_prod_global_001.enabled
	http_port  = var.afdo_project102_prod_global_001.http_port
	https_port = var.afdo_project102_prod_global_001.https_port
	origin_host_header = module.lb_project102_prod_westeurope_001.name
	priority   = var.afdo_project102_prod_global_001.priority
	private_link = var.afdo_project102_prod_global_001.private_link
	weight     = var.afdo_project102_prod_global_001.weight
}