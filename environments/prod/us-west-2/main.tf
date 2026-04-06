terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# AgentCore resources enforce different naming regexes per resource type:
#   - aws_bedrockagentcore_gateway        : ^([0-9a-zA-Z][-]?){1,100}$  (hyphens OK, underscores NOT)
#   - aws_bedrockagentcore_memory         : ^[a-zA-Z][a-zA-Z0-9_]{0,47}$ (underscores OK, hyphens NOT)
#   - aws_bedrockagentcore_agent_runtime  : ^[a-zA-Z][a-zA-Z0-9_]{0,47}$ (underscores OK, hyphens NOT)
# AWS-native resources (IAM, Lambda, Cognito, ECR) accept hyphens freely.
locals {
  # For gateway: keep hyphens, strip any underscores
  ac_gateway_prefix = replace("${var.app_name}-${var.environment}", "_", "-")
  # For memory and runtime: replace hyphens with underscores
  ac_safe_prefix = replace("${var.app_name}_${var.environment}", "-", "_")
}

module "tagging" {
  source      = "../../../modules/tagging"
  app_name    = var.app_name
  environment = var.environment
  region      = var.aws_region
  extra_tags  = var.additional_tags
}

module "ecr" {
  source          = "../../../modules/ecr"
  repository_name = "${var.app_name}-${var.environment}-runtime"
  tags            = module.tagging.common_tags
}

module "iam_lambda" {
  source            = "../../../modules/iam-lambda"
  role_name         = "${var.app_name}-${var.environment}-mcp-lambda-role"
  extra_policy_arns = []
  tags              = module.tagging.common_tags
}

# Dynamically creates one Lambda function per subfolder found in lambda_s3_bucket.
# No function names, S3 keys, or versions need to be specified manually.
module "mcp_lambdas" {
  source           = "../../../modules/mcp-lambdas"
  lambda_s3_bucket = var.lambda_s3_bucket
  name_prefix      = "${var.app_name}-${var.environment}"
  role_arn         = module.iam_lambda.role_arn
  tags             = module.tagging.common_tags
}

module "iam_gateway" {
  source          = "../../../modules/iam-gateway"
  role_name       = "${var.app_name}-${var.environment}-gateway-role"
  mcp_lambda_arns = module.mcp_lambdas.function_arn_list
  tags            = module.tagging.common_tags
}

module "cognito_jwt_auth" {
  source                     = "../../../modules/cognito-jwt-auth"
  name_prefix                = "${var.app_name}-${var.environment}"
  domain_prefix              = "${var.app_name}-${var.environment}-auth"
  resource_server_identifier = "${var.app_name}-${var.environment}-api"
  scope_name                 = "gateway.invoke"
  aws_region                 = var.aws_region
  tags                       = module.tagging.common_tags
}

# One gateway target is created per discovered Lambda function.
module "agentcore_gateway" {
  source          = "../../../modules/agentcore-gateway"
  gateway_name    = "${local.ac_gateway_prefix}-gateway"
  role_arn        = module.iam_gateway.role_arn
  discovery_url   = module.cognito_jwt_auth.discovery_url
  allowed_clients = [module.cognito_jwt_auth.client_id]
  mcp_lambda_arns = {
    for k in module.mcp_lambdas.function_keys :
    k => module.mcp_lambdas.function_arns[k]
  }
  tags            = module.tagging.common_tags
}

module "agentcore_memory" {
  source                     = "../../../modules/agentcore-memory"
  memory_name                = "${local.ac_safe_prefix}_memory"
  description                = "AgentCore memory for ${var.app_name} ${var.environment}"
  user_preference_name       = "user_preference"
  user_preference_namespaces = ["agentcore/user-preference"]
  semantic_name              = "semantic"
  semantic_namespaces        = ["agentcore/semantic"]
  summarization_name         = "summarization"
  summarization_namespaces   = ["agentcore/{sessionId}/summarization"]
  tags                       = module.tagging.common_tags
}

module "iam_agent_runtime" {
  source         = "../../../modules/iam-agent-runtime"
  role_name      = "${var.app_name}-${var.environment}-runtime-role"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  tags           = module.tagging.common_tags
}

# agent_runtime_image_uri is resolved automatically from the ECR data source.
# Every terraform apply picks up the most recently pushed image — no manual URI updates needed.
module "agentcore_runtime" {
  source                           = "../../../modules/agentcore-runtime"
  runtime_name                     = "${local.ac_safe_prefix}_runtime"
  role_arn                         = module.iam_agent_runtime.role_arn
  agent_runtime_image_uri          = module.ecr.latest_image_uri
  memory_id                        = module.agentcore_memory.memory_id
  gateway_url                      = module.agentcore_gateway.gateway_url
  cognito_token_url                = module.cognito_jwt_auth.token_url
  cognito_client_id                = module.cognito_jwt_auth.client_id
  cognito_client_secret            = module.cognito_jwt_auth.client_secret
  cognito_scope                    = module.cognito_jwt_auth.scope
  network_mode                     = "PUBLIC"
  additional_environment_variables = var.additional_runtime_environment_variables
  tags                             = module.tagging.common_tags
}

# AgentCore automatically creates a DEFAULT endpoint when the runtime is provisioned.
# No additional endpoint resources are managed here.
