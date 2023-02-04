module "rds" {
  source               = "../implementation"
  platform_environment = "iqa"

  component   = var.component
  environment = var.environment
  team        = var.team

  engine_major_version = var.engine_major_version
  instance_size        = var.instance_size
}
