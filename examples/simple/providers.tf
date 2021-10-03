provider "aws" {
  region  = var.region
  profile = "login"

  allowed_account_ids = [var.allowed_account_id]
  assume_role {
    role_arn     = "arn:aws:iam::${var.allowed_account_id}:role/${var.role_to_assume}"
    session_name = "tf-cloudfront-module-example"
  }
}

provider "aws" {
  alias   = "lambda"
  region  = "us-east-1"
  profile = "login"

  allowed_account_ids = [var.allowed_account_id]
  assume_role {
    role_arn     = "arn:aws:iam::${var.allowed_account_id}:role/${var.role_to_assume}"
    session_name = "tf-cloudfront-module-example"
  }
}
