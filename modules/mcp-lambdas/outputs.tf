# Map of { function_folder_name -> function_arn } for all discovered Lambda functions.
# Use this to configure gateway targets (one target per function).
output "function_arns" {
  description = "Map of function name (folder key) to Lambda function ARN."
  value       = { for k, fn in aws_lambda_function.functions : k => fn.arn }
}

# Flat list of all Lambda ARNs.
# Use this for IAM policies that need to allow invocation of all functions.
output "function_arn_list" {
  description = "Flat list of all Lambda function ARNs."
  value       = [for fn in aws_lambda_function.functions : fn.arn]
}

# Set of discovered function folder names, resolved from the S3 data source.
# Keys are known at plan time, making them safe to use as for_each keys downstream.
output "function_keys" {
  description = "Set of discovered function names (folder keys). Known at plan time — safe for downstream for_each keys."
  value       = toset(keys(local.function_s3_keys))
}

# Map of { function_folder_name -> function_name } for reference.
output "function_names" {
  description = "Map of function name (folder key) to deployed Lambda function name."
  value       = { for k, fn in aws_lambda_function.functions : k => fn.function_name }
}
