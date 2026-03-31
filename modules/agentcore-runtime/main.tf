locals {
  base_environment_variables = {
    AGENTCORE_MEMORY_ID   = var.memory_id
    AGENTCORE_GATEWAY_URL = var.gateway_url
    COGNITO_TOKEN_URL     = var.cognito_token_url
    COGNITO_CLIENT_ID     = var.cognito_client_id
    COGNITO_CLIENT_SECRET = var.cognito_client_secret
    COGNITO_SCOPE         = var.cognito_scope
  }
}

resource "aws_bedrockagentcore_agent_runtime" "this" {
  agent_runtime_name = var.runtime_name
  role_arn           = var.role_arn

  agent_runtime_artifact {
    container_configuration {
      container_uri = var.agent_runtime_image_uri
    }
  }

  network_configuration {
    network_mode = var.network_mode
  }

  environment_variables = merge(local.base_environment_variables, var.additional_environment_variables)
  tags                  = var.tags
}
