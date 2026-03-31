variable "role_name" {
  type = string
}

variable "extra_policy_arns" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
