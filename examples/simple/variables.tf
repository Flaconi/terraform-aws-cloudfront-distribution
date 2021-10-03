variable "allowed_account_id" {
  description = "AWS account ID for which this module can be executed"
  type        = string
}

variable "role_to_assume" {
  description = "IAM role name to assume (eg. ASSUME-ROLE)"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS Region where to create CloudFront distribution"
  type        = string
  default     = "eu-central-1"
}
