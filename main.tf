terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.43.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}


# Call the CI IAM module
module "ci-iam" {
  source = "./tf-iam"
  prefix = "prod"
  tags = {
    "Module" = "iam",
    "Owner"  = "Sr. Dev"
  }
}