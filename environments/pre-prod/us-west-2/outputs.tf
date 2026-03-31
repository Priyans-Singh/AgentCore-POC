output "runtime_arn" {
  value = module.agentcore_runtime.runtime_arn
}

output "gateway_url" {
  value = module.agentcore_gateway.gateway_url
}

output "cognito_client_id" {
  value = module.cognito_jwt_auth.client_id
}
