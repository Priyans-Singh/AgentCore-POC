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

module "mcp_lambda" {
  source            = "../../../modules/mcp-lambda"
  function_name     = "${var.app_name}-${var.environment}-mcp"
  role_arn          = module.iam_lambda.role_arn
  handler           = "index.handler"
  runtime           = "python3.11"
  s3_bucket         = var.mcp_lambda_s3_bucket
  s3_key            = var.mcp_lambda_s3_key
  s3_object_version = var.mcp_lambda_s3_object_version
  tags              = module.tagging.common_tags
}

module "iam_gateway" {
  source         = "../../../modules/iam-gateway"
  role_name      = "${var.app_name}-${var.environment}-gateway-role"
  mcp_lambda_arn = module.mcp_lambda.lambda_arn
  tags           = module.tagging.common_tags
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

module "agentcore_gateway" {
  source          = "../../../modules/agentcore-gateway"
  gateway_name    = "${var.app_name}-${var.environment}-gateway"
  role_arn        = module.iam_gateway.role_arn
  discovery_url   = module.cognito_jwt_auth.discovery_url
  allowed_clients = [module.cognito_jwt_auth.client_id]
  mcp_lambda_arn  = module.mcp_lambda.lambda_arn
  target_name     = "mcp-lambda-target"
  tags            = module.tagging.common_tags
}

module "agentcore_memory" {
  source                    = "../../../modules/agentcore-memory"
  memory_name               = "${var.app_name}-${var.environment}-memory"
  description               = "AgentCore memory for ${var.app_name} ${var.environment}"
  user_preference_name      = "user-preference"
  user_preference_namespaces = ["agentcore/user-preference"]
  semantic_name             = "semantic"
  semantic_namespaces       = ["agentcore/semantic"]
  summarization_name        = "summarization"
  summarization_namespaces  = ["agentcore/summarization"]
  tags                      = module.tagging.common_tags
}

module "iam_agent_runtime" {
  source         = "../../../modules/iam-agent-runtime"
  role_name      = "${var.app_name}-${var.environment}-runtime-role"
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  tags           = module.tagging.common_tags
}

module "agentcore_runtime" {
  source                           = "../../../modules/agentcore-runtime"
  runtime_name                     = "${var.app_name}-${var.environment}-runtime"
  role_arn                         = module.iam_agent_runtime.role_arn
  agent_runtime_image_uri          = var.agent_runtime_image_uri
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

module "agentcore_runtime_endpoints" {
  source                            = "../../../modules/agentcore-runtime-endpoints"
  agent_runtime_id                  = module.agentcore_runtime.runtime_id
  runtime_endpoint_prod_version     = var.runtime_endpoint_prod_version
  runtime_endpoint_pre_prod_version = var.runtime_endpoint_pre_prod_version
}
