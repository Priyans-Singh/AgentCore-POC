terraform {
  backend "s3" {
    bucket = "replace-me-terraform-state-pre-prod"
    key    = "agentcore/pre-prod/us-west-2/terraform.tfstate"
    region = "us-west-2"
  }
}
