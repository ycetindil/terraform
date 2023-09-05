module "afdog_project102_prod_global_001" { // phonebook front door origin group
	source = "github.com/ycetindil/terraform/tree/main/modules/azure/cdn_frontdoor_origin_group"

	name                                   = var.afdog_project102_prod_global_001.name
	cdn_frontdoor_profile_id = module.afd_project102_prod_global_001.id
	load_balancing = var.afdog_project102_prod_global_001.load_balancing
	health_probes = var.afdog_project102_prod_global_001.health_probes
	restore_traffic_time_to_healed_or_new_endpoint_in_minutes = var.afdog_project102_prod_global_001.restore_traffic_time_to_healed_or_new_endpoint_in_minutes
	session_affinity_enabled                                  = var.afdog_project102_prod_global_001.session_affinity_enabled
}