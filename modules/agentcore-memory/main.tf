resource "aws_bedrockagentcore_memory" "this" {
  name                  = var.memory_name
  description           = var.description
  event_expiry_duration = var.event_expiry_duration
  tags                  = var.tags
}

resource "aws_bedrockagentcore_memory_strategy" "user_preference" {
  memory_id  = aws_bedrockagentcore_memory.this.id
  name       = var.user_preference_name
  type       = "USER_PREFERENCE"
  namespaces = var.user_preference_namespaces
}

resource "aws_bedrockagentcore_memory_strategy" "semantic" {
  memory_id  = aws_bedrockagentcore_memory.this.id
  name       = var.semantic_name
  type       = "SEMANTIC"
  namespaces = var.semantic_namespaces
}

resource "aws_bedrockagentcore_memory_strategy" "summarization" {
  memory_id  = aws_bedrockagentcore_memory.this.id
  name       = var.summarization_name
  type       = "SUMMARIZATION"
  namespaces = var.summarization_namespaces
}
