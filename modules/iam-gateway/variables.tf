variable "role_name" {
  type = string
}

variable "mcp_lambda_arns" {
  description = "List of MCP Lambda function ARNs the gateway role is permitted to invoke."
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
