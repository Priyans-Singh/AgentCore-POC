terraform {
  backend "s3" {
    # bucket and region are injected at runtime via -backend-config flags:
    #   terraform init -backend-config="bucket=$TF_STATE_BUCKET" \
    #                  -backend-config="region=$AWS_REGION"
    # Both are set as GitHub Actions environment variables for this env.
    key = "agentcore/prod/us-west-2/terraform.tfstate"
  }
}
