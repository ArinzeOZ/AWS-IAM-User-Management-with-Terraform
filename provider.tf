terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = var.primary
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary
}
