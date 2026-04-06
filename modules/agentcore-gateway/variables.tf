variable "gateway_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "discovery_url" {
  type = string
}

variable "allowed_clients" {
  type = list(string)
}

# Map of { function_folder_name -> lambda_arn }.
# One aws_bedrockagentcore_gateway_target is created per entry.
variable "mcp_lambda_arns" {
  description = "Map of MCP function name to Lambda ARN. One gateway target is created per entry."
  type        = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
