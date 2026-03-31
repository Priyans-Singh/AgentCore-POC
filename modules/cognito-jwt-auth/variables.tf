variable "name_prefix" {
  type = string
}

variable "domain_prefix" {
  type = string
}

variable "resource_server_identifier" {
  type = string
}

variable "scope_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
