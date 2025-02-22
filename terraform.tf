terraform {
  required_version = ">=1.4.5"

  backend "s3" {
    profile        = "511510396203_AWSAdministratorAccess" #Legacy account
    bucket         = "terraform-gilienv-eu-west-1"
    key            = "aws-master-account/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_state"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = ["123456789101"]
  profile             = "123456789101_AWSAdministratorAccess"
}
