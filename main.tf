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

data "aws_eip" "vault_ip" {
  filter {
    name   = "tag:name"
    values = [var.vault_ip_name]
  }
}
