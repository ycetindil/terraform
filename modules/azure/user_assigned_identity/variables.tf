variable "location" {
  description = <<EOD
		(Required) The Azure Region where the User Assigned Identity should exist.
		Changing this forces a new User Assigned Identity to be created.
	EOD
  type        = string
}

variable "name" {
  description = <<EOD
		 - (Required) Specifies the name of this User Assigned Identity.
		Changing this forces a new User Assigned Identity to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		 - (Required) Specifies the name of the Resource Group within which this User Assigned Identity should exist.
		Changing this forces a new User Assigned Identity to be created.
	EOD
  type        = string
}

variable "tags" {
  description = <<EOD
		 - (Optional) A mapping of tags which should be assigned to the User Assigned Identity.
	EOD
  default     = null
  type        = map(string)
}