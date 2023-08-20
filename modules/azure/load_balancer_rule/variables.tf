variable "name" {
  description = <<EOD
		(Required) Specifies the name of the LB Rule.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "loadbalancer_id" {
  description = <<EOD
		(Required) The ID of the Load Balancer in which to create the Rule.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "frontend_ip_configuration_name" {
  description = <<EOD
		(Required) The name of the frontend IP configuration to which the rule is associated.
	EOD
  type        = string
}

variable "protocol" {
  description = <<EOD
		(Required) The transport protocol for the external endpoint.
		Possible values are Tcp, Udp or All.
	EOD
  type        = string
}

variable "frontend_port" {
  description = <<EOD
		(Required) The port for the external endpoint.
		Port numbers for each Rule must be unique within the Load Balancer.
		Possible values range between 0 and 65534, inclusive.
	EOD
  type        = number
}

variable "backend_port" {
  description = <<EOD
		(Required) The port used for internal connections on the endpoint.
		Possible values range between 0 and 65535, inclusive.
	EOD
  type        = number
}

variable "backend_address_pool_ids" {
  description = <<EOD
		(Optional) A list of reference to a Backend Address Pool over which this Load Balancing Rule operates.
		NOTE: In most cases users can only set one Backend Address Pool ID in the backend_address_pool_ids. Especially, when the sku of the LB is Gateway, users can set up to two IDs in the backend_address_pool_ids.
	EOD
  default     = null
  type        = list(string)
}

variable "probe_id" {
  description = <<EOD
		(Optional) A reference to a Probe used by this Load Balancing Rule.
	EOD
  default     = null
  type        = string
}

variable "enable_floating_ip" {
  description = <<EOD
		(Optional) Are the Floating IPs enabled for this Load Balncer Rule?
		A "floating” IP is reassigned to a secondary server in case the primary server fails.
		Required to configure a SQL AlwaysOn Availability Group.
		Defaults to false.
	EOD
  default     = null
  type        = bool
}

variable "idle_timeout_in_minutes" {
  description = <<EOD
		(Optional) Specifies the idle timeout in minutes for TCP connections.
		Valid values are between 4 and 30 minutes.
		Defaults to 4 minutes.
	EOD
  default     = null
  type        = number
}

variable "load_distribution" {
  description = <<EOD
		(Optional) Specifies the load balancing distribution type to be used by the Load Balancer.
		Possible values are:
		- Default: The load balancer is configured to use a 5 tuple hash to map traffic to available servers.
		- SourceIP: The load balancer is configured to use a 2 tuple hash to map traffic to available servers.
		- SourceIPProtocol: The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively.
	EOD
  default     = null
  type        = string
}

variable "disable_outbound_snat" {
  description = <<EOD
		(Optional) Is snat enabled for this Load Balancer Rule?
		Default false.
	EOD
  default     = null
  type        = bool
}

variable "enable_tcp_reset" {
  description = <<EOD
		(Optional) Is TCP Reset enabled for this Load Balancer Rule?
	EOD
  default     = null
  type        = bool
}