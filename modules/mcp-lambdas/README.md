# module: mcp-lambdas

Dynamically creates one AWS Lambda function per subfolder found in the specified S3 bucket.
No Lambda names, keys, or versions need to be manually specified — they are fully discovered at apply time.

## How it works

1. Terraform lists top-level "folders" (common prefixes) in `lambda_s3_bucket` using `data.aws_s3_objects`.
2. For each folder, it reads a plaintext `latest` pointer file (e.g. `tool_search/latest`) containing the zip filename for the current deployment.
3. It creates one `aws_lambda_function` per discovered folder, pointing at the zip the pointer resolves to.

Every `terraform apply` re-reads the pointer files. If app CI has pushed a new zip and updated `latest`, the Lambda is updated automatically.

## Required S3 structure

```
{lambda_s3_bucket}/
  {function-name}/
    abc123.zip      <- artifact named after git commit SHA
    latest          <- plaintext: "abc123.zip"
  {other-function}/
    def456.zip
    latest          <- plaintext: "def456.zip"
```

## App CI responsibility

After uploading a new zip, app CI must update the `latest` pointer:

```bash
echo "${GITHUB_SHA}.zip" | aws s3 cp - s3://${LAMBDA_S3_BUCKET}/${FUNCTION_NAME}/latest
```

## Inputs

| Name | Type | Description |
|------|------|-------------|
| `lambda_s3_bucket` | `string` | S3 bucket name (one per environment) |
| `name_prefix` | `string` | Prefix for all Lambda function names |
| `role_arn` | `string` | IAM execution role shared by all functions |
| `tags` | `map(string)` | Tags applied to all Lambda resources |

## Outputs

| Name | Description |
|------|-------------|
| `function_arns` | Map of folder name to Lambda ARN (use for gateway targets) |
| `function_arn_list` | Flat list of all ARNs (use for IAM invoke policies) |
| `function_names` | Map of folder name to deployed function name |
