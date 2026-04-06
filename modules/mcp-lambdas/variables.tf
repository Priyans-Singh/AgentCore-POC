variable "lambda_s3_bucket" {
  description = "S3 bucket containing one subfolder per Lambda function. Each subfolder must contain a 'latest' pointer file and the corresponding zip artifact."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to every Lambda function name. Resulting name: {name_prefix}-{folder_name}."
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN assigned to all Lambda functions in this module."
  type        = string
}

variable "tags" {
  description = "Tags applied to all Lambda function resources."
  type        = map(string)
  default     = {}
}
