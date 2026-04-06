variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

# Injected from GitHub Actions environment variable AWS_ACCOUNT_ID via TF_VAR_aws_account_id.
variable "aws_account_id" {
  type = string
}

# Injected from GitHub Actions environment variable LAMBDA_S3_BUCKET via TF_VAR_lambda_s3_bucket.
# One bucket per environment; contains one subfolder per Lambda function.
variable "lambda_s3_bucket" {
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
