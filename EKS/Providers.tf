provider "aws" {
  region = local.region

}

terraform {

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"
    }

  }


 backend "s3" {
    bucket         = "vermeg-eks-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "vermeg-eks-terraform-locks"
    encrypt        = true
  }

}