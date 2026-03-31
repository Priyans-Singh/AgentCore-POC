resource "aws_bedrockagentcore_agent_runtime_endpoint" "prod" {
  agent_runtime_id      = var.agent_runtime_id
  name                  = "PROD"
  agent_runtime_version = var.runtime_endpoint_prod_version
}

resource "aws_bedrockagentcore_agent_runtime_endpoint" "pre_prod" {
  agent_runtime_id      = var.agent_runtime_id
  name                  = "PRE-PROD"
  agent_runtime_version = var.runtime_endpoint_pre_prod_version
  depends_on            = [aws_bedrockagentcore_agent_runtime_endpoint.prod]
}
