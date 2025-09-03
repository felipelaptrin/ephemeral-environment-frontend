locals {
  project = "ephemeral-environments"

  account_id = data.aws_caller_identity.current.account_id

  frontend_bucket_name           = "${var.environment}-${local.account_id}-frontend"
  frontend_ephemeral_bucket_name = "${local.frontend_bucket_name}-ephemeral"
}
