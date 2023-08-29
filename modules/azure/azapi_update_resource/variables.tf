variable "name" {
  description = <<EOD
		(Optional) Specifies the name of the azure resource.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "parent_id" {
  description = <<EOD
		(Optional) The ID of the azure resource in which this resource is created.
		Changing this forces a new resource to be created.
		It supports different kinds of deployment scope for top level resources:
		- resource group scope: parent_id should be the ID of a resource group, it's recommended to manage a resource group by azurerm_resource_group.
		- management group scope: parent_id should be the ID of a management group, it's recommended to manage a management group by azurerm_management_group.
		- extension scope: parent_id should be the ID of the resource you're adding the extension to.
		- subscription scope: parent_id should be like /subscriptions/00000000-0000-0000-0000-000000000000
		- tenant scope: parent_id should be /
		- For child level resources, the parent_id should be the ID of its parent resource, for example, subnet resource's parent_id is the ID of the vnet.
	EOD
  type        = string
}

variable "resource_id" {
  description = <<EOD
		(Optional) The ID of an existing azure source.
		Changing this forces a new azure resource to be created.
		Note: Configuring name and parent_id is an alternative way to configure resource_id.
	EOD
  type        = string
}

variable "type" {
  description = <<EOD
		(Required) It is in a format like <resource-type>@<api-version>. <resource-type> is the Azure resource type, for example, Microsoft.Storage/storageAccounts. <api-version> is version of the API used to manage this azure resource.
	EOD
  type        = string
}

variable "body" {
  description = <<EOD
		(Required) A JSON object that contains the request body used to add on an existing azure resource.
	EOD
  type        = string
}

variable "response_export_values" {
  description = <<EOD
		(Optional) A list of path that needs to be exported from response body. Setting it to ["*"] will export the full response body. See the example at https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_update_resource#response_export_values.
	EOD
  default     = null
  type        = list(string)
}

variable "locks" {
  description = <<EOD
		(Optional) A list of ARM resource IDs which are used to avoid create/modify/delete azapi resources at the same time.
	EOD
  default     = null
  type        = list(string)
}

variable "ignore_casing" {
  description = <<EOD
		(Optional) Whether ignore incorrect casing returned in body to suppress plan-diff.
		Defaults to false.
	EOD
  default     = null
  type        = bool
}

variable "ignore_missing_property" {
  description = <<EOD
		(Optional) Whether ignore not returned properties like credentials in body to suppress plan-diff.
		Defaults to true.
	EOD
  default     = null
  type        = bool
}