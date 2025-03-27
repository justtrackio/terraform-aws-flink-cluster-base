module "sentry" {
  count   = module.this.enabled && var.sentry_enabled ? 1 : 0
  source  = "justtrackio/project/sentry"
  version = "1.4.2"

  context     = module.this.context
  label_order = var.label_orders.sentry
  platform    = "java"
}
