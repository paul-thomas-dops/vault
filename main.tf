terraform {
  backend "s3" {
    bucket         = "egp-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    owner   = "Paul Thomas"
    project = "Hashicorp Vault"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vault-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = merge(local.tags, { Name = "vault-vpc" })
}
