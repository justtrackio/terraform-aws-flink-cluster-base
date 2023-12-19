locals {
  policies  = concat([data.aws_iam_policy_document.policy.json], var.policies)
  role_name = "${module.this.environment}-${var.kubernetes_namespace}-flink-cluster"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::${module.this.environment}-flink-${module.this.aws_account_id}-${module.this.aws_region}",
      "arn:aws:s3:::${module.this.namespace}-${module.this.organizational_unit}-datalake",
    ]
  }
  statement {
    actions = [
      "s3:Get*",
      "s3:Delete*",
      "s3:Put*",
      "s3:AbortMultipartUpload",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${module.this.environment}-flink-${module.this.aws_account_id}-${module.this.aws_region}/*",
      "arn:aws:s3:::${module.this.namespace}-${module.this.organizational_unit}-datalake/*",
    ]
  }
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "*",
    ]
  }
}

module "cluster_role_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.32.0"

  for_each = { for k, policy in local.policies : k => policy }

  name        = "${module.this.environment}-${var.kubernetes_namespace}-flink-cluster-${each.key}"
  path        = "/"
  description = "Policy to allow flink apps access to the required aws resources via role: ${local.role_name}"

  policy = each.value
}

module "cluster_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.32.0"

  create_role = true

  role_name = local.role_name

  provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  role_policy_arns = [for k, policy in local.policies : module.cluster_role_policy[k].arn]

  oidc_subjects_with_wildcards = ["system:serviceaccount:${var.kubernetes_namespace}:*"]
}

module "ecr_applications" {
  for_each = { for app in var.applications : app => app }

  source  = "cloudposse/ecr/aws"
  version = "0.38.0"

  context     = module.this.context
  name        = each.key
  label_order = var.label_orders.ecr

  force_delete        = true
  max_image_count     = 10
  scan_images_on_push = false
}
