variable "location" {
  description = <<EOD
		(Required) The Azure Region where the Windows Web App should exist.
		Changing this forces a new Windows Web App to be created.
	EOD
  type        = string
}

variable "name" {
  description = <<EOD
		(Required) The name which should be used for this Windows Web App.
		Changing this forces a new Windows Web App to be created.
	EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
		(Required) The name of the Resource Group where the Windows Web App should exist.
		Changing this forces a new Windows Web App to be created.
	EOD
  type        = string
}

variable "service_plan_id" {
  description = <<EOD
		(Required) The ID of the Service Plan that this Windows App Service will be created in.
	EOD
  type        = string
}

variable "site_config" {
  description = <<EOD
    (Required) A site_config block as defined below.
    A site_config block supports the following:
    - always_on - (Optional) If this Windows Web App is Always On enabled.
      Defaults to true.
      NOTE: always_on must be explicitly set to false when using Free, F1, D1, or Shared Service Plans.
    - application_stack - (Optional) A application_stack block as defined above.
      An application_stack block supports the following:
			- current_stack - (Optional) The Application Stack for the Windows Web App.
				Possible values include dotnet, dotnetcore, node, python, php, and java.
				NOTE: Whilst this property is Optional omitting it can cause unexpected behaviour, in particular for display of settings in the Azure Portal.
      - docker_image_name - (Optional) The docker image, including tag, to be used. e.g. appsvc/staticsite:latest.
      - docker_registry_url - (Optional) The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com.
        This value is required with docker_image_name.
      - docker_registry_username - (Optional) The User Name to use for authentication against the registry to pull the image.
      - docker_registry_password - (Optional) The Password to use for authentication against the registry to pull the image.
      NOTE: docker_registry_url, docker_registry_username, and docker_registry_password replace the use of the app_settings values of DOCKER_REGISTRY_SERVER_URL, DOCKER_REGISTRY_SERVER_USERNAME and DOCKER_REGISTRY_SERVER_PASSWORD respectively, these values will be managed by the provider and should not be specified in the app_settings map.
      - dotnet_version - (Optional) The version of .NET to use when current_stack is set to dotnet.
				Possible values include v2.0,v3.0, v4.0, v5.0, v6.0 and v7.0.
				NOTE: The Portal displayed values and the actual underlying API values differ for this setting, as at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app#dotnet_version.
      - dotnet_core_version - (Optional) The version of .NET to use when current_stack is set to dotnetcore.
				Possible values include v4.0.
			- tomcat_version - (Optional) The version of Tomcat the Java App should use.
				Conflicts with java_embedded_server_enabled
				NOTE: See the official documentation for current supported versions. Some example valuess include: 10.0, 10.0.20.
			- java_embedded_server_enabled - (Optional) Should the Java Embedded Server (Java SE) be used to run the app.
			- java_version - (Optional) The version of Java to use when current_stack is set to java.
				NOTE: For currently supported versions, please see the official documentation. Some example values include: 1.8, 1.8.0_322, 11, 11.0.14, 17 and 17.0.2
			- node_version - (Optional) The version of node to use when current_stack is set to node.
				Possible values are ~12, ~14, ~16, and ~18.
				NOTE: This property conflicts with java_version.
			- php_version - (Optional) The version of PHP to use when current_stack is set to php.
				Possible values are 7.1, 7.4 and Off.
				NOTE: The value Off is used to signify latest supported by the service.
			- python - (Optional) Specifies whether this is a Python app.
				Defaults to false.
    - container_registry_use_managed_identity - (Optional) Should connections for Azure Container Registry use Managed Identity.
    - vnet_route_all_enabled - (Optional) Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied?
      Defaults to false.
  EOD
  type = object({
    always_on = optional(bool)
    application_stack = optional(object({
      current_stack                = optional(string)
      docker_image_name            = optional(string)
      docker_registry_url          = optional(string)
      docker_registry_username     = optional(string)
      docker_registry_password     = optional(string)
      dotnet_version               = optional(string)
      dotnet_core_version          = optional(string)
      tomcat_version               = optional(string)
      java_embedded_server_enabled = optional(bool)
      java_version                 = optional(string)
      node_version                 = optional(string)
      php_version                  = optional(string)
      python_version               = optional(bool)
    }))
    container_registry_use_managed_identity = optional(bool)
    vnet_route_all_enabled                  = optional(bool)
  })
}

variable "app_settings" {
  description = <<EOD
		(Optional) A map of key-value pairs of App Settings.
	EOD
  default     = null
  type        = map(string)
}

variable "connection_strings" {
  description = <<EOD
		(Optional) One or more connection_string blocks as defined below.
		A connection_string block supports the following:
		- name - (Required) The name of the Connection String.
		- type - (Required) Type of database.
			Possible values include: APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure, and SQLServer.
		- value - (Required) The connection string value.
	EOD
  default     = {}
  type = map(object({
    name  = string
    type  = string
    value = string
  }))
}

variable "https_only" {
  description = <<EOD
		(Optional) Should the Windows Web App require HTTPS connections.
	EOD
  default     = null
  type        = bool
}

variable "public_network_access_enabled" {
  description = <<EOD
		(Optional) Should public network access be enabled for the Web App.
		Defaults to true.
	EOD
  default     = null
  type        = bool
}

variable "identity" {
  description = <<EOD
		(Optional) An identity block as defined below.
		An identity block supports the following:
		- type - (Required) Specifies the type of Managed Service Identity that should be configured on this Windows Web App. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
		- identity_ids - (Optional) A list of User Assigned Managed Identity IDs to be assigned to this Windows Web App.
			NOTE: This is required when type is set to UserAssigned or SystemAssigned, UserAssigned.
	EOD
  default     = null
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
}

variable "logs" {
  description = <<EOD
    (Optional) A logs block as defined below.
    A logs block supports the following:
    - application_logs - (Optional) A application_logs block as defined below.
      An application_logs block supports the following:
      - azure_blob_storage - (Optional) An azure_blob_storage block as defined below.
        An azure_blob_storage block supports the following:
        - level - (Required) The level at which to log.
          Possible values include Error, Warning, Information, Verbose and Off.
          NOTE: this field is not available for http_logs
        - retention_in_days - (Required) The time in days after which to remove blobs.
          A value of 0 means no retention.
        - sas_url - (Required) SAS url to an Azure blob container with read/write/list/delete permissions.
      - file_system_level - (Required) Log level.
        Possible values include: Verbose, Information, Warning, and Error.
    - detailed_error_messages - (Optional) Should detailed error messages be enabled?
    - failed_request_tracing - (Optional) Should the failed request tracing be enabled?
    - http_logs - (Optional) An http_logs block as defined below.
      A http_logs block supports the following:
      - azure_blob_storage - (Optional) A azure_blob_storage_http block as defined below.
        An azure_blob_storage_http block supports the following:
        - retention_in_days - (Optional) The time in days after which to remove blobs.
          A value of 0 means no retention.
        - sas_url - (Required) SAS url to an Azure blob container with read/write/list/delete permissions.
      - file_system - (Optional) A file_system block as defined below.
        A file_system block supports the following:
        - retention_in_days - (Required) The retention period in days.
					A value of 0 means no retention.
        - retention_in_mb - (Required) The maximum size in megabytes that log files can use.
  EOD
  default     = null
  type = object({
    application_logs = optional(object({
      azure_blob_storage = optional(object({
        level             = string
        retention_in_days = number
        sas_url           = string
      }))
      file_system_level = string
    }))
    detailed_error_messages = optional(bool)
    failed_request_tracing  = optional(bool)
    http_logs = optional(object({
      azure_blob_storage = optional(object({
        retention_in_days = number
        sas_url           = string
      }))
      file_system = optional(object({
        retention_in_days = number
        retention_in_mb   = number
      }))
    }))
  })
}

variable "tags" {
  description = <<EOD
		(Optional) A mapping of tags which should be assigned to the Windows Web App.
	EOD
  default     = null
  type        = map(string)
}

variable "virtual_network_subnet_id" {
  description = <<EOD
		(Optional) The subnet id which will be used by this Web App for regional virtual network integration.
		NOTE on regional virtual network integration: The AzureRM Terraform provider provides regional virtual network integration via the standalone resource app_service_virtual_network_swift_connection and in-line within this resource using the virtual_network_subnet_id property. You cannot use both methods simultaneously. If the virtual network is set via the resource app_service_virtual_network_swift_connection then ignore_changes should be used in the web app configuration.
		Note: Assigning the virtual_network_subnet_id property requires RBAC permissions on the subnet
	EOD
  default     = null
  type        = string
}