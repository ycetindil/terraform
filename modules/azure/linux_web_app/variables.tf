variable "location" {
  description = <<EOD
    (Required) The Azure Region where the Linux Web App should exist.
    Changing this forces a new Linux Web App to be created.
  EOD
  type        = string
}

variable "name" {
  description = <<EOD
    (Required) The name which should be used for this Linux Web App.
    Changing this forces a new Linux Web App to be created.
    NOTE: Terraform will perform a name availability check as part of the creation progress, if this Web App is part of an App Service Environment terraform will require Read permission on the ASE for this to complete reliably.
  EOD
  type        = string
}

variable "resource_group_name" {
  description = <<EOD
    (Required) The name of the Resource Group where the Linux Web App should exist.
    Changing this forces a new Linux Web App to be created.
  EOD
  type        = string
}

variable "service_plan_id" {
  description = <<EOD
    (Required) The ID of the Service Plan that this Linux App Service will be created in.
  EOD
  type        = string
}

variable "site_config" {
  description = <<EOD
    (Required) A site_config block as defined below.
    A site_config block supports the following:
    - always_on - (Optional) If this Linux Web App is Always On enabled.
      Defaults to true.
      NOTE: always_on must be explicitly set to false when using Free, F1, D1, or Shared Service Plans.
    - application_stack - (Optional) A application_stack block as defined above.
      An application_stack block supports the following:
      - docker_image_name - (Optional) The docker image, including tag, to be used. e.g. appsvc/staticsite:latest.
      - docker_registry_url - (Optional) The URL of the container registry where the docker_image_name is located. e.g. https://index.docker.io or https://mcr.microsoft.com.
        This value is required with docker_image_name.
      - docker_registry_username - (Optional) The User Name to use for authentication against the registry to pull the image.
      - docker_registry_password - (Optional) The Password to use for authentication against the registry to pull the image.
      NOTE: docker_registry_url, docker_registry_username, and docker_registry_password replace the use of the app_settings values of DOCKER_REGISTRY_SERVER_URL, DOCKER_REGISTRY_SERVER_USERNAME and DOCKER_REGISTRY_SERVER_PASSWORD respectively, these values will be managed by the provider and should not be specified in the app_settings map.
      - dotnet_version - (Optional) The version of .NET to use.
        Possible values include 3.1, 5.0, 6.0 and 7.0.
      - go_version - (Optional) The version of Go to use.
        Possible values include 1.18, and 1.19.
      - java_server - (Optional) The Java server type.
        Possible values include JAVA, TOMCAT, and JBOSSEAP.
        NOTE: JBOSSEAP requires a Premium Service Plan SKU to be a valid option.
      - java_server_version - (Optional) The Version of the java_server to use.
      - java_version - (Optional) The Version of Java to use. Possible values include 8, 11, and 17.
        NOTE: The valid version combinations for java_version, java_server and java_server_version can be checked from the command line via az webapp list-runtimes --linux.
      - node_version - (Optional) The version of Node to run.
        Possible values include 12-lts, 14-lts, 16-lts, and 18-lts.
        This property conflicts with java_version.
        NOTE: 10.x versions have been/are being deprecated so may cease to work for new resources in the future and may be removed from the provider.
      - php_version - (Optional) The version of PHP to run.
        Possible values are 8.0, 8.1 and 8.2.
        NOTE: version 7.4 is deprecated and will be removed from the provider in a future version.
      - python_version - (Optional) The version of Python to run.
        Possible values include 3.7, 3.8, 3.9, 3.10 and 3.11.
      - ruby_version - (Optional) The version of Ruby to run.
        Possible values include 2.6 and 2.7.
    - container_registry_use_managed_identity - (Optional) Should connections for Azure Container Registry use Managed Identity.
    - vnet_route_all_enabled - (Optional) Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied?
      Defaults to false.
  EOD
  type = object({
    always_on = optional(bool)
    application_stack = optional(object({
      docker_image_name        = optional(string)
      docker_registry_url      = optional(string)
      docker_registry_username = optional(string)
      docker_registry_password = optional(string)
      dotnet_version           = optional(string)
      go_version               = optional(string)
      java_server              = optional(string)
      java_server_version      = optional(string)
      java_version             = optional(string)
      node_version             = optional(string)
      php_version              = optional(string)
      python_version           = optional(string)
      ruby_version             = optional(string)
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
      Possible values include: MySQL, SQLServer, SQLAzure, Custom, NotificationHub, ServiceBus, EventHub, APIHub, DocDb, RedisCache, and PostgreSQL.
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
    (Optional) Should the Linux Web App require HTTPS connections.
  EOD
  default     = null
  type        = bool
}

variable "'public_network_access_enabled'" {
  description = <<EOD
    Should public network access be enabled for the Web App.
    Defaults to true.
  EOD
  default     = null
  type        = bool
}

variable "identity" {
  description = <<EOD
    (Optional) An identity block as defined below.
    An identity block supports the following:
    - type - (Required) Specifies the type of Managed Service Identity that should be configured on this Linux Web App.
      Possible values are SystemAssigned, UserAssigned, and SystemAssigned, UserAssigned (to enable both).
    - identity_ids - (Optional) A list of User Assigned Managed Identity IDs to be assigned to this Linux Web App.
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

variable "virtual_network_subnet_id" {
  description = <<EOD
    (Optional) The subnet id which will be used by this Web App for regional virtual network integration.
    NOTE on regional virtual network integration: The AzureRM Terraform provider provides regional virtual network integration via the standalone resource app_service_virtual_network_swift_connection and in-line within this resource using the virtual_network_subnet_id property. You cannot use both methods simultaneously. If the virtual network is set via the resource app_service_virtual_network_swift_connection (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) then ignore_changes should be used in the web app configuration.
    Note: Assigning the virtual_network_subnet_id property requires RBAC permissions on the subnet as described at https://docs.microsoft.com/en-us/azure/app-service/overview-vnet-integration#permissions.
  EOD
  default     = null
  type        = string
}

variable "tags" {
  description = <<EOD
    (Optional) A mapping of tags which should be assigned to the Linux Web App.
  EOD
  default     = null
  type        = map(string)
}