variable "name" {
  description = <<EOD
		(Required) Specifies the name of the Backend Address Pool.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "loadbalancer_id" {
  description = <<EOD
		(Required) The ID of the Load Balancer in which to create the Backend Address Pool.
		Changing this forces a new resource to be created.
	EOD
  type        = string
}

variable "tunnel_interfaces" {
  description = <<EOD
		(Optional) One or more tunnel_interface blocks as defined below.
		The tunnel_interface block supports the following:
		- identifier - (Required) The unique identifier of this Gateway Lodbalancer Tunnel Interface.
		- type - (Required) The traffic type of this Gateway Lodbalancer Tunnel Interface.
			Possible values are None, Internal and External.
		- protocol - (Required) The protocol used for this Gateway Lodbalancer Tunnel Interface.
			Possible values are None, Native and VXLAN.
		- port - (Required) The port number that this Gateway Lodbalancer Tunnel Interface listens to.
	EOD
  default     = null
  type = object({
    identifier = number
    type       = string
    protocol   = string
    port       = number
  })
}

variable "virtual_network_id" {
  description = <<EOD
		(Optional) The ID of the Virtual Network within which the Backend Address Pool should exist.
	EOD
  type        = string
}