variable "role_name" {
  type = string
}

variable "mcp_lambda_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
