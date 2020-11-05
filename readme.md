# INTRODUCTION

## Terraform code to perform following actions,

Completed
- AWS S3 Bucket Creation
- IAM role with specified policies for
  - S3 
  - CloudWatch Logs
  - DynamoDB
- Lambda function to schedule Python function execution
- Lambda S3 CSV object creation event trigger (S3 Bucekt Notification)
- Dynamo DB table creation with 3 attributes
- REST API endpoint creation

Pending
- Python function to read CSV and upload it to DynamoDB table.
- Create an Authenticated(token based) Rest API endpoints that do CRUD on the records stored in DynamoDB after CSV file upload
- Secret Manager to store credentials 

# PRE-REQUISITES
Terraform 12 binary should be installed. Please follow [official link](https://releases.hashicorp.com/terraform/) for setup.


# INSTRUCTION

### Root module is present under `./build` directory
- Clone the repository 
```
git clone https://github.com/iamaftabshaikh/scalereal-tf.git
```


- Preprare AWS IAM role with appropriate permission to use with Terraform 

- Download Secret and Access key and store it under `./build` directory with `.secret.tfvars` file as per following,
```
access_key = "AKIxxxxxxxxxxxxxxxx"
secret_key = "otYrsTTm1X+xxxxxxxxxxxxxxxxxxxxxxxxxxx"
```
Note: It is not desirable to store credential locally in a plain text, it should be stored in a vault and should be supplied to terraform during runtime.

- Change directory to `build`
```
cd build
```

- Validate and Plan terraform 
```
terraform init
terraform validate
terraform plan --var-file=.secret.tfvars
```

- Upon secessfull terraform plan and validate, execute apply command
```
terraform apply --var-file=.secret.tfvars
```

