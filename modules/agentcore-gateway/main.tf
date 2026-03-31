resource "aws_bedrockagentcore_gateway" "this" {
  name            = var.gateway_name
  role_arn        = var.role_arn
  authorizer_type = "CUSTOM_JWT"
  protocol_type   = "MCP"

  authorizer_configuration {
    custom_jwt_authorizer {
      discovery_url    = var.discovery_url
      allowed_audience = var.allowed_clients
    }
  }

  tags = var.tags
}

resource "aws_bedrockagentcore_gateway_target" "mcp_lambda" {
  gateway_identifier = aws_bedrockagentcore_gateway.this.gateway_id
  name               = var.target_name

  credential_provider_configuration {
    gateway_iam_role {}
  }

  target_configuration {
    mcp {
      lambda {
        lambda_arn = var.mcp_lambda_arn

        tool_schema {
          inline_payload {
            name        = var.tool_schema.name
            description = var.tool_schema.description

            input_schema {
              type = "object"
            }

            output_schema {
              type = "object"
            }
          }
        }
      }
    }
  }
}
