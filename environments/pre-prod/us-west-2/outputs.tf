output "runtime_arn" {
  description = "AgentCore runtime ARN."
  value       = module.agentcore_runtime.runtime_arn
}

output "runtime_id" {
  description = "AgentCore runtime ID."
  value       = module.agentcore_runtime.runtime_id
}

output "gateway_url" {
  description = "AgentCore gateway URL."
  value       = module.agentcore_gateway.gateway_url
}

output "cognito_client_id" {
  description = "Cognito app client ID used for gateway JWT auth."
  value       = module.cognito_jwt_auth.client_id
}

output "ecr_repository_url" {
  description = "ECR repository URL for the agent runtime image."
  value       = module.ecr.repository_url
}

output "active_image_uri" {
  description = "Fully-qualified image URI (including digest) currently deployed to the runtime."
  value       = module.ecr.latest_image_uri
}

output "lambda_function_arns" {
  description = "Map of MCP Lambda function name to ARN for all dynamically-discovered functions."
  value       = module.mcp_lambdas.function_arns
}
