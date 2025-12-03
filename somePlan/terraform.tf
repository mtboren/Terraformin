terraform {
  ## for using Hashicorp Cloud Platform ("HCP") Terraform instead of local
/*   cloud {
    organization = "mattCoolOrg"

    workspaces {
      project = "Learn Terraform"
      name = "learn-terraform-aws-get-started"
    }
  } */

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
  required_version = ">= 1.13"
}