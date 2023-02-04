# These are dependencies from other 'stacks' or otherwise provisioned infrastructure.
# Terraform dependencies across repository and potentially teams should be as loosly coupled as possible.
# Hence it may make sense to use variables and not even ssm_parameter or other config stores.
# However this is acceptable for now as YAGNI, KISS and eventually these configurations would not even be expose to
# 'application' teams, eg. 'subnet ids', 'vpc id'. They would be part of the infra templates (eg. crossplane) and the
# 'users' application teams would only configure 'db versions', size and other relevant parameters.
locals {
  platform_environment = var.platform_environment
  platform_dependency_prefix = "platform-${local.platform_environment}"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "${local.platform_dependency_prefix}-vpc-id"
}

data "aws_ssm_parameter" "database_subnets" {
  name = "${local.platform_dependency_prefix}-database-subnets"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
  name = "${local.platform_dependency_prefix}-database-subnet-group-name"
}

data "aws_ssm_parameter" "eks_primary_sg" {
  name = "${local.platform_dependency_prefix}-eks-primary-sg"
}

data "aws_ssm_parameter" "eks_cluster_id" {
  name = "${local.platform_dependency_prefix}-eks-cluster-id"
}

data "aws_ssm_parameter" "eks_admin_role" {
  name = "${local.platform_dependency_prefix}-eks-admin-role-arn"
}

locals {
  eks_admin_role                    = data.aws_ssm_parameter.eks_admin_role.value
  cluster_primary_security_group_id = data.aws_ssm_parameter.eks_primary_sg.value
  database_subnets                  = toset(jsondecode(data.aws_ssm_parameter.database_subnets.value))
  database_subnet_group_name        = data.aws_ssm_parameter.database_subnet_group_name.value
  eks_cluster_id                    = data.aws_ssm_parameter.eks_cluster_id.value
  vpc_id                            = data.aws_ssm_parameter.vpc_id.value
}
