terraform {
  backend "s3" {
    bucket = "replace-me-terraform-state-prod"
    key    = "agentcore/prod/us-west-2/terraform.tfstate"
    region = "us-west-2"
  }
}
