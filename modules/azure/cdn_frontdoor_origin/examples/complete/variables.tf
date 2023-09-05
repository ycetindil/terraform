variable "afdo_project102_prod_global_001" { // west europe ilb
	name                           = "afdo-project102-prod-global-001"
	# cdn_frontdoor_origin_group is provided by root 'main.tf'.
	# host_name is provided by root 'main.tf'.
	certificate_name_check_enabled = true
	enabled                        = true
	http_port  = 80
	https_port = 443
	# origin_host_header is provided by root 'main.tf'.
	priority   = 1
	private_link = {
		request_message = "Gimme gimme"
		location        = "West Europe"
		target = {
			name                = "pl-project102-prod-westeurope-001"
			resource_group_name = "rg-project102-prod-westeurope-001"
		}
	}
	weight     = 500
}