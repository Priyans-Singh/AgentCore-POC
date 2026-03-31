variable "runtime_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "agent_runtime_image_uri" {
  type = string
}

variable "memory_id" {
  type = string
}

variable "gateway_url" {
  type = string
}

variable "cognito_token_url" {
  type = string
}

variable "cognito_client_id" {
  type = string
}

variable "cognito_client_secret" {
  type = string
}

variable "cognito_scope" {
  type = string
}

variable "network_mode" {
  type = string
}
variable "additional_environment_variables" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
