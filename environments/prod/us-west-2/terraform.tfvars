app_name    = "agentcore-demo"
environment = "prod"
aws_region  = "eu-west-2"

# aws_account_id    -- set via GitHub Actions environment variable: AWS_ACCOUNT_ID  (TF_VAR_aws_account_id)
# lambda_s3_bucket  -- set via GitHub Actions environment variable: LAMBDA_S3_BUCKET (TF_VAR_lambda_s3_bucket)
# agent_runtime_image_uri is no longer an input; resolved automatically from the ECR data source.
# Lambda S3 keys are no longer inputs; discovered dynamically from the S3 bucket at apply time.

additional_tags = {
  Owner = "personal-project"
}

additional_runtime_environment_variables = {
  LOG_LEVEL = "INFO"
}
