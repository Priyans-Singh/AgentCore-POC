output "prod_endpoint_arn" {
  value = aws_bedrockagentcore_agent_runtime_endpoint.prod.agent_runtime_endpoint_arn
}

output "pre_prod_endpoint_arn" {
  value = aws_bedrockagentcore_agent_runtime_endpoint.pre_prod.agent_runtime_endpoint_arn
}
