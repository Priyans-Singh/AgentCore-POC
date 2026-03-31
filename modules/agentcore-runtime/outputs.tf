output "runtime_arn" {
  value = aws_bedrockagentcore_agent_runtime.this.agent_runtime_arn
}

output "runtime_id" {
  value = aws_bedrockagentcore_agent_runtime.this.agent_runtime_id
}

output "runtime_version" {
  value = aws_bedrockagentcore_agent_runtime.this.agent_runtime_version
}
