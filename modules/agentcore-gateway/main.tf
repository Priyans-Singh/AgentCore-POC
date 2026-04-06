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

# One gateway target per discovered Lambda function.
# Target name matches the S3 folder name (= the logical MCP tool name).
resource "aws_bedrockagentcore_gateway_target" "mcp_lambdas" {
  for_each = var.mcp_lambda_arns

  gateway_identifier = aws_bedrockagentcore_gateway.this.gateway_id
  name               = replace(each.key, "_", "-")

  credential_provider_configuration {
    gateway_iam_role {}
  }

  target_configuration {
    mcp {
      lambda {
        lambda_arn = each.value

        tool_schema {
          inline_payload {
            name        = replace(each.key, "_", "-")
            description = "MCP tool provided by Lambda function ${each.key}."

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
