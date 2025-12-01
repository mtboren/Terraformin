terraform {
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