variable "component" {
  description = "The component that depends on this resource. Do not set value in config. Value is injected bye convention"
  type        = string
}
variable "environment" {
  description = "The app environment for this resource. Do not set value in config. Value is injected bye convention"
  type        = string
}
variable "team" {
  description = "The team that owns this component. Do not value in config. Value is injected bye convention"
  type        = string
}

variable "engine_major_version" {
  description = "The major version of the RDS PG Engine"
  type        = string
}

variable "instance_size" {
  type = string
  description = "The size of the RDS Aurora DB instance to launch. Valid values: small, medium, large, xlarge."
  validation {
    condition = can(regex("^(small|medium|large|xlarge)$", var.instance_size))
    error_message = "Invalid instance size. Valid values are: small, medium, large, xlarge."
  }
}
