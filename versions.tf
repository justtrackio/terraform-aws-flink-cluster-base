terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }

    sentry = {
      source  = "jianyuan/sentry"
      version = "0.14.9"
    }
  }

  required_version = ">= 1.3.0"
}
