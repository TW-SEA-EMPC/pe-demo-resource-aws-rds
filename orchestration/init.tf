terraform {
  backend "s3" {
    region = "ap-southeast-1"
    bucket = "empc-sea-pe-demo-tf-state"
    # <platform-environment>/<component>-<environment>-<stack>
    key    = "iqa/test-app-100-pre-prod-rds"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
    kubernetes ={
      source = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }
  required_version = "~> 1.3.6"
}

provider "aws" {
  region = "ap-southeast-1"
}
