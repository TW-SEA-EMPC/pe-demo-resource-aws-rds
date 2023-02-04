# To be fixed
variable "platform_environment" {
  description = "The environment for the platform, eg. dev, iqa, prod"
  type = string
}

# To be set by convention, templating
variable "environment" {
  description = "The environment for the application eg. pre-prod, prod"
  type = string
}
variable "component" {
  description = "The component that depends on this resource"
  type        = string
}
variable "team" {
  description = "Required variable for setting the team that owns the database"
  type        = string
}

# API for product teams
variable "engine_major_version" {
  description = "Required variable for setting the major version of the database engine"
  type        = string
}
variable "instance_size" {
  description = "Required variable for setting the instance size of the database"
  type        = string
}
