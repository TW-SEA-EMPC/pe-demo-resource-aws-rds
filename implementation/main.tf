locals {
  team        = var.team
  component   = var.component
  environment = var.environment
  stack       = "rds"
  name        = "${local.component}-${local.environment}-${local.stack}"
  tags = {
    component   = local.component
    owner       = local.team
    team        = local.team
    stack       = local.stack
    environment = local.environment
  }
}

module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"

  name           = local.name
  engine         = "aurora-postgresql"
  engine_version = var.engine_major_version
  instance_class = "db.t3.medium"
  instances = {
    one = {}
  }

  vpc_id                 = local.vpc_id
  create_db_subnet_group = false
  db_subnet_group_name   = local.database_subnet_group_name
  subnets                = local.database_subnets

  allowed_security_groups = [local.cluster_primary_security_group_id]
#  allowed_cidr_blocks     = ["10.0.0.0/20"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.db.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db.name

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(local.tags, {
    Name = local.name
  })
}

resource "aws_db_parameter_group" "db" {
  name   = local.name
  family = "aurora-postgresql11"
  tags = merge(local.tags, {
    Name : local.name
  })
}

resource "aws_rds_cluster_parameter_group" "db" {
  name   = local.name
  family = "aurora-postgresql11"
  tags = merge(local.tags, {
    Name : local.name
  })
}

// EKS Secret
data "aws_eks_cluster" "default" {
  name = local.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    #tflint-fix
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.name, "--role-arn", local.eks_admin_role]
    command     = "aws"
  }
}

// This secret name is sort of like config store for infra to pass on data to the application layer
// The name is agreed on by convention, changing the name will break the test and whatever subsequent applications
resource "kubernetes_secret_v1" "app-a-rds-creds" {
  metadata {
    name      = "${local.name}-connection"

    # By convention the NS are pre-prod-apps and prod-apps
    namespace = "${local.environment}-apps"
  }
  data = {
    # Have to be the same as the backstage helm values.yaml
    POSTGRES_HOST = module.cluster.cluster_endpoint,
    POSTGRES_PORT = module.cluster.cluster_port,
    POSTGRES_USER = module.cluster.cluster_master_username,
    POSTGRES_PASSWORD = module.cluster.cluster_master_password,
  }
}
