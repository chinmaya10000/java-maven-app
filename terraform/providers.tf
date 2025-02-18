provider "aws" {
  region = local.aws_region
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.87.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}
