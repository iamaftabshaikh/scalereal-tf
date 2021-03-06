/**
 * 
 * 
 * Copyright 2020 ITWox Inc.
 * 
 * All rights reserved in ITWox Inc. authored and generated code, including the
 * selection and arrangement of the source code base regardless of the authorship
 * of individual files.......
 *
 */
# ===========================================
# TERRAFORM LOCAL DECLARATION
# ===========================================
locals {
  resource_count = 1
  
  common_tags = {
    Environment = title(var.environment)
    Costcenter  = var.costcenter
    Department  = title(var.department)
    Owner       = title(var.resource_owner)
    Contact     = title(var.technical_owner)
    Managed_by  = "Terraform"
  }
}

# ====================================================================
# TERRAFORM S3 BUCKET CREATION MODULE
# Create S3 bucket
# ====================================================================
module "s3_lambda_bucket" {
  source = "../modules/s3"
  
  bucket_name    = "aws1234dev-bucket"
  resource_count = local.resource_count
  environment    = "Dev"
  bucket_acl     = "private"
  request_payer  = "BucketOwner"
  force_destroy  = true
  common_tags    = local.common_tags
}

# ====================================================================
# TERRAFORM IAM ROLE MODULE
# Create IAM role and assign policies
# ====================================================================
module "lambda_iam_role" {
  source = "../modules/iam"
  
  resource_count  = local.resource_count
  role_name       = "CustomIAMRoleForLambda"
  iam_description = "IAM role for lambda for s3 access"
  common_tags     = local.common_tags
}

# ====================================================================
# TERRAFORM LAMBDA MODULE
# Create lambda function and event trigger
# ====================================================================
module "create_lambda_function" {
  source = "../modules/lambda"
  
  resource_count      = local.resource_count
  common_tags         = local.common_tags
  runtime             = "python3.6"
  event_filter_suffix = ".csv"

  # module references
  lambda_role_arn_module = module.lambda_iam_role.iam_role_arn
  s3_bucket_id_module    = module.s3_lambda_bucket.bucket_id
  s3_bucket_arn_module   = module.s3_lambda_bucket.bucket_arn
}

# ====================================================================
# TERRAFORM DYNAMO DB MODULE
# Create AWS DynamoDB table resource
# ====================================================================
module "dynamodb_table" {
  source = "../modules/dynamo"
  
  resource_count = local.resource_count
  name           = "DynamoDB_CSV_Table"
  billing_mode   = "PROVISIONED"
  hash_key       = "Id"
  range_key      = "First"
  read_capacity  = 20
  write_capacity = 20
  gsi_name       = "UserTitleIndex"
  common_tags    = local.common_tags
  
  ttl_attribute_name = "TimeToExist"
  attributes = [
    {
      name = "Id"
      type = "N"
    },
    {
      name = "First"
      type = "S"
    }
  ]

}

# ====================================================================
# TERRAFORM REST API GATEWAY MODULE
# Create REST API gateway
# ====================================================================
module "rest_api" {
  source = "../modules/api_gateway"

  resource_count = local.resource_count
  api_name       = "DynamoCRUDOperationAPI"
  endpoint_type  = "REGIONAL"

}
