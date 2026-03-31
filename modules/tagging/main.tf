locals {
  common_tags = merge(
    {
      Application = var.app_name
      Environment = var.environment
      Region      = var.region
      ManagedBy   = "terraform"
    },
    var.extra_tags
  )
}
