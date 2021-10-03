# Module Example
This is an example of the AWS Cloudfront Distribution with the module in use. The `main.tf` exhibits the module definition. Pay special attention to the `source` variable, as it is calling a specific reference tag of the module. It is highly encouraged to follow the same pattern to avoid any breaking changes as updates to the module are released. Please note the syntax of the variable definitions in the `terraform.tfvars` file for adding and removing multiple items.

## Terraform Backend
It may be important to store the state of the terraform configuration remotely. This will ensure that your resources can be referenced from multiple locations. If you too feel this is important **PLEASE** be sure to update the [Terraform-Backend](https://github.com/jmgreg31/terraform-aws-cloudfront/blob/master/example/main.tf#L119-L126) section in your configuration where:

* `bucket`  = Your S3 bucket
* `key`     = The folder location within your s3 bucket
* `region`  = AWS Region
* `encrypt` = true

Otherwise, this section can be removed.  Due to terraform limitations, these can not be variables within the configuration.  However, terraform does offer a way to pass these variables in at runtime.

Example:
```
terraform init \
-backend-config="bucket=my-bucket" \
-backend-config="key=cloudfront/terraform.tfstate" \
-backend-config="region=us-east-1" \
-backend-config="encrypt=true"
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_aws.lambda"></a> [aws.lambda](#provider\_aws.lambda) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../.. | n/a |
| <a name="module_contentBucket"></a> [contentBucket](#module\_contentBucket) | github.com/terraform-aws-modules/terraform-aws-s3-bucket.git | v2.9.0 |
| <a name="module_logBucket"></a> [logBucket](#module\_logBucket) | github.com/terraform-aws-modules/terraform-aws-s3-bucket.git | v2.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_account_id"></a> [allowed\_account\_id](#input\_allowed\_account\_id) | AWS account ID for which this module can be executed | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region where to create CloudFront distribution | `string` | `"eu-central-1"` | no |
| <a name="input_role_to_assume"></a> [role\_to\_assume](#input\_role\_to\_assume) | IAM role name to assume (eg. ASSUME-ROLE) | `string` | `""` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
