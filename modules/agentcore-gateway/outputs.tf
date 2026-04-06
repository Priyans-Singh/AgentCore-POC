output "gateway_arn" {
  value = aws_bedrockagentcore_gateway.this.gateway_arn
}

output "gateway_id" {
  value = aws_bedrockagentcore_gateway.this.gateway_id
}

output "gateway_url" {
  value = aws_bedrockagentcore_gateway.this.gateway_url
}

# Map of { function_name -> gateway_target_id } for all created targets.
output "target_ids" {
  description = "Map of Lambda function name to gateway target ID."
  value       = { for k, t in aws_bedrockagentcore_gateway_target.mcp_lambdas : k => t.target_id }
}
