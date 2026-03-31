output "discovery_url" {
  value = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.this.id}/.well-known/openid-configuration"
}

output "client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "client_secret" {
  value     = aws_cognito_user_pool_client.this.client_secret
  sensitive = true
}

output "token_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com/oauth2/token"
}

output "scope" {
  value = "${aws_cognito_resource_server.this.identifier}/${var.scope_name}"
}
