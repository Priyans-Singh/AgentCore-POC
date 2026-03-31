# AgentCore Infrastructure Terraform

This repository is **infrastructure-only** Terraform for AgentCore.

## Boundary

- No application source code is stored or built here.
- No Docker build/push logic is implemented in Terraform.
- No local packaging/zipping scripts are used by Terraform.
- Infrastructure consumes prebuilt artifacts only.

## Artifact Inputs

Infrastructure expects external artifact pipelines to provide:

- `agent_runtime_image_uri`: prebuilt container image URI for AgentCore runtime.
- `mcp_lambda_s3_bucket`, `mcp_lambda_s3_key`, `mcp_lambda_s3_object_version`: prebuilt Lambda artifact in S3.

## Environment Entrypoints

- `environments/prod/us-west-2`
- `environments/pre-prod/us-west-2`

Each environment root is thin and composes reusable modules from `modules/`.

## Standard Terraform Commands

Run from an environment folder (example: `environments/prod/us-west-2`):

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply
```
