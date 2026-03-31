variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "agent_runtime_image_uri" {
  type = string
}

variable "mcp_lambda_s3_bucket" {
  type = string
}

variable "mcp_lambda_s3_key" {
  type = string
}

variable "mcp_lambda_s3_object_version" {
  type = string
}

variable "runtime_endpoint_prod_version" {
  type = string
}

variable "runtime_endpoint_pre_prod_version" {
  type = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "additional_runtime_environment_variables" {
  type    = map(string)
  default = {}
}
