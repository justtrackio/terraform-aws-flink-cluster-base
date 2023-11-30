provider "aws" {
  region = "eu-central-1"
}

provider "sentry" {
  base_url = "http://sentry.${module.this.organizational_unit}-monitoring.${var.domain}"
  token    = data.aws_ssm_parameter.sentry_token.value
}
