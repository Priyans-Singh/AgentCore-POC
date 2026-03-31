variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
