variable "afdog_project102_prod_global_001" { // phonebook front door origin group
	name                                                      = "afdog-project102-prod-global-001"
	# cdn_frontdoor_profile_id is provided by root 'main.tf'.
	load_balancing = {
		additional_latency_in_milliseconds = 0
		sample_size                        = 16
		successful_samples_required        = 3
	}
	health_probes = {
		http = {
			interval_in_seconds = 240
			path                = "/"
			protocol            = "Http"
			request_type        = "GET"
		}
	}
	restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
	session_affinity_enabled                                  = false
}