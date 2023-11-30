variable "kubernetes_namespace" {
  type        = string
  description = "the kubernetes namespace thats services accounts are allowed to assume the role"
}

variable "policies" {
  type        = list(string)
  description = "policy as json via aws_iam_policy_document data source"
}

variable "applications" {
  type        = list(string)
  description = "list of applications to create ecr repositories for"
}
