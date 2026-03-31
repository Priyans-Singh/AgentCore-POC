variable "memory_name" {
  type = string
}

variable "description" {
  type    = string
  default = "AgentCore memory resource"
}

variable "event_expiry_duration" {
  type    = number
  default = 30
}

variable "user_preference_name" {
  type = string
}

variable "user_preference_namespaces" {
  type = list(string)
}

variable "semantic_name" {
  type = string
}

variable "semantic_namespaces" {
  type = list(string)
}

variable "summarization_name" {
  type = string
}

variable "summarization_namespaces" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
