resource "aws_cognito_user_pool" "this" {
  name = "${var.name_prefix}-pool"
  tags = var.tags
}

resource "aws_cognito_resource_server" "this" {
  identifier   = var.resource_server_identifier
  name         = "${var.name_prefix}-resource-server"
  user_pool_id = aws_cognito_user_pool.this.id

  scope {
    scope_name        = var.scope_name
    scope_description = "Scope for AgentCore gateway"
  }
}

resource "aws_cognito_user_pool_client" "this" {
  name                                 = "${var.name_prefix}-client"
  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["${aws_cognito_resource_server.this.identifier}/${var.scope_name}"]
  generate_secret                      = true
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}
