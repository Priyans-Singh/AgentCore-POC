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

variable "mcp_lambda_arn" {
  type = string
}

variable "target_name" {
  type = string
}
variable "tool_schema" {
  type = object({
    name        = string
    description = string
  })
  default = {
    name        = "placeholder_tool"
    description = "Placeholder MCP tool schema for initial provisioning."
  }
}
variable "tags" {
  type    = map(string)
  default = {}
}
