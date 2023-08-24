variable "name" {
  description = <<EOD
		 - (Required) The name which should be used for this Policy Assignment.
		Changing this forces a new Policy Assignment to be created.
		Cannot exceed 64 characters in length.
	EOD
  type        = string
}

variable "policy_definition_id" {
  description = <<EOD
		 - (Required) The ID of the Policy Definition or Policy Definition Set.
		Changing this forces a new Policy Assignment to be created.
	EOD
  type        = string
}

variable "subscription_id" {
  description = <<EOD
		 - (Required) The ID of the Subscription where this Policy Assignment should be created.
		Changing this forces a new Policy Assignment to be created.
	EOD
  type        = string
}