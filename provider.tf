# provider.tf
# AWS Provider Configuration

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  # Default tags applied to all resources
  default_tags {
    tags = {
      Project     = "SecureVPC"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Owner       = "SecurityTeam"
    }
  }
}