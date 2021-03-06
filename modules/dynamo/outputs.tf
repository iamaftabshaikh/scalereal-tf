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

output "dynamo_arn" {
  value       = aws_dynamodb_table.dynamo_csv[*].arn
  description = "ARN of the DynamoDB table"
}

output "dynamo_id" {
  value       = aws_dynamodb_table.dynamo_csv[*].id
  description = "ID of the DynamoDB table"
}
