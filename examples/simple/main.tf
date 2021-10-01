module "logBucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v2.9.0"

  bucket_prefix = "flaconi-cft-log-"
}

module "contentBucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v2.9.0"

  bucket_prefix = "flaconi-cft-content-"
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Example identity"
}

resource "aws_iam_role" "lambda_role" {
  name = "ci-example-lambda-role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
            "Service": [
               "lambda.amazonaws.com",
               "edgelambda.amazonaws.com"
            ]
         },
         "Action": "sts:AssumeRole"
      }
   ]
}
EOF
}

resource "aws_lambda_function" "this" {
  provider      = aws.lambda
  function_name = "ci-example-lambda"
  role          = aws_iam_role.lambda_role.arn

  runtime  = "python3.7"
  filename = "lambda.zip"
  handler  = "lambda_handler"
  publish  = true

  source_code_hash = filebase64sha256("lambda.zip")
}

module cloudfront {
  source                   = "../.."
  retain_on_delete         = false
  comment                  = "AWS Cloudfront Module"
  enabled                  = true
  minimum_protocol_version = "TLSv1.1_2016"
  region                   = var.region
  price_class              = "PriceClass_100"
  is_ipv6_enabled          = false
  aliases                  = []
  web_acl_id               = ""
  http_version             = "http2"
  tag_name                 = "tagname"
  iam_certificate_id       = null
  default_root_object      = null
  wait_for_deployment      = false
  tags                     = {}
  custom_origin_config     = local.custom_origin_config
  s3_origin_config         = local.s3_origin_config
  origin_groups            = []

  custom_error_response  = local.custom_error_response
  default_cache_behavior = local.default_cache_behavior
  ordered_cache_behavior = local.ordered_cache_behavior

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["US", "CA", "GB", "DE"]
  }

  logging_config = {
    bucket          = module.logBucket.s3_bucket_bucket_domain_name
    include_cookies = false
    prefix          = "prefix"
  }
}

locals {
  custom_origin_config = [
    {
      domain_name              = "wikipedia.org"
      origin_id                = "wiki"
      origin_path              = "/wiki"
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1", "SSLv3"]
    },
    {
      domain_name              = "google.com"
      origin_id                = "google"
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2", "SSLv3"]
    },
  ]

  s3_origin_config = [
    {
      domain_name            = module.contentBucket.s3_bucket_bucket_domain_name
      origin_id              = "contentBucket"
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    },
  ]


  default_cache_behavior = [
    {
      allowed_methods         = ["DELETE", "POST", "GET", "HEAD", "PATCH", "OPTIONS", "PUT"]
      cached_methods          = ["GET", "HEAD"]
      target_origin_id        = "wiki"
      compress                = false
      query_string            = true
      query_string_cache_keys = []
      cookies_forward         = "all"
      headers                 = ["Host"]
      viewer_protocol_policy  = "redirect-to-https"
      min_ttl                 = 0
      default_ttl             = 0
      max_ttl                 = 300
    }
  ]

  ordered_cache_behavior = [
    {
      path_pattern                 = "/simple_path/*"
      allowed_methods              = ["GET", "HEAD"]
      cached_methods               = ["GET", "HEAD"]
      target_origin_id             = "wiki"
      compress                     = true
      query_string                 = true
      query_string_cache_keys      = []
      cookies_forward              = "none"
      headers                      = []
      viewer_protocol_policy       = "redirect-to-https"
      min_ttl                      = 0
      default_ttl                  = 600
      max_ttl                      = 600
      whitelisted_names            = []
      lambda_function_associations = []
    },
    {
      path_pattern                 = "/path/null"
      allowed_methods              = ["DELETE", "POST", "GET", "HEAD", "PATCH", "OPTIONS", "PUT"]
      cached_methods               = ["GET", "HEAD"]
      target_origin_id             = "wiki"
      compress                     = true
      query_string                 = true
      query_string_cache_keys      = []
      cookies_forward              = "none"
      headers                      = ["*"]
      viewer_protocol_policy       = "redirect-to-https"
      min_ttl                      = 0
      default_ttl                  = 0
      max_ttl                      = 0
      whitelisted_names            = []
      lambda_function_associations = []
    },
    {
      path_pattern            = "/lambda/"
      allowed_methods         = ["DELETE", "POST", "GET", "HEAD", "PATCH", "OPTIONS", "PUT"]
      cached_methods          = ["GET", "HEAD"]
      target_origin_id        = "contentBucket"
      compress                = true
      query_string            = true
      query_string_cache_keys = []
      cookies_forward         = "none"
      whitelisted_names       = []
      headers                 = ["X-lambda"]
      viewer_protocol_policy  = "redirect-to-https"
      min_ttl                 = 0
      default_ttl             = 0
      max_ttl                 = 300
      lambda_function_associations = [{
        event_type   = "viewer-request"
        include_body = false
        lambda_arn   = aws_lambda_function.this.qualified_arn
      }]
    }
  ]
  custom_error_response = []
}
