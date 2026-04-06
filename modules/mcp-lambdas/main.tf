# Discovers all Lambda function folders in the S3 bucket.
# Each top-level "folder" (common prefix) maps to one Lambda function.
# The bucket structure expected:
#   {lambda_s3_bucket}/
#     {function-name}/
#       {sha}.zip       <- deployment artifact, named after git commit SHA
#       latest          <- plaintext pointer file containing "{sha}.zip"
#
# App CI must write the `latest` pointer after each upload:
#   echo "${GITHUB_SHA}.zip" | aws s3 cp - s3://<bucket>/<function-name>/latest

data "aws_s3_objects" "function_folders" {
  bucket    = var.lambda_s3_bucket
  delimiter = "/"
}

# Read the `latest` pointer file for every discovered function folder.
data "aws_s3_object" "latest_pointer" {
  for_each = toset([
    for prefix in data.aws_s3_objects.function_folders.common_prefixes :
    trimsuffix(prefix, "/")
  ])
  bucket = var.lambda_s3_bucket
  key    = "${each.key}/latest"
}

locals {
  # Build a map of { function_name -> s3_key_to_current_zip }
  function_s3_keys = {
    for name, obj in data.aws_s3_object.latest_pointer :
    name => "${name}/${trimspace(obj.body)}"
  }
}

resource "aws_lambda_function" "functions" {
  for_each = local.function_s3_keys

  function_name = "${var.name_prefix}-${each.key}"
  role          = var.role_arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"

  s3_bucket = var.lambda_s3_bucket
  s3_key    = each.value

  tags = var.tags
}
