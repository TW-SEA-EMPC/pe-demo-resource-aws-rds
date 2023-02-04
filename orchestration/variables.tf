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
  description = "The instance size of the RDS instance"
  type        = string
}
