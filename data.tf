data "aws_eks_cluster" "cluster" {
  name = "${module.this.organizational_unit}-${module.this.stage}"
}

data "aws_ssm_parameter" "sentry_token" {
  name = "/sentry/token"
}
