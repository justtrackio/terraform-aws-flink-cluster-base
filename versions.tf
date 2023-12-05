terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }

    sentry = {
      source  = "jianyuan/sentry"
      version = "0.11.2"
    }
  }

  required_version = ">= 1.3.0"
}
