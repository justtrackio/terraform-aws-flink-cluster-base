variable "applications" {
  type        = list(string)
  description = "list of applications to create ecr repositories for"
}

variable "domain" {
  type        = string
  description = "The default domain"
}

variable "kubernetes_namespace" {
  type        = string
  description = "the kubernetes namespace thats services accounts are allowed to assume the role"
}

variable "label_orders" {
  type = object({
    ecr    = optional(list(string)),
    sentry = optional(list(string), ["stage", "name"]),
  })
  default     = {}
  description = "Overrides the `labels_order` for the different labels to modify ID elements appear in the `id`"
}

variable "policies" {
  type        = list(string)
  description = "policy as json via aws_iam_policy_document data source"
}

variable "sentry_enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources for sentry"
  default     = true
}
