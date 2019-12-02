provider aws {
  region = "us-east-1"
}

module cloudfront {
  source                   = "../"
  retain_on_delete         = false
  comment                  = "AWS Cloudfront Module"
  enabled                  = true
  minimum_protocol_version = "TLSv1.1_2016"
  region                   = "us-east-1"
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
    bucket          = "bucket"
    include_cookies = false
    prefix          = "prefix"
  }
}

locals {
  custom_origin_config = [
    {
      domain_name              = "wikipedia.org"
      origin_id                = "existing_origin"
      origin_path              = "/s/red/null-service/metrics"
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1", "SSLv3"]
    },
    {
      domain_name              = "google.com"
      origin_id                = "internetServicesViaAmbassador"
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
      domain_name            = "simple-bucket.s3.amazonaws.com"
      origin_id              = "sitemapBucket"
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    },
    {
      domain_name = "anotherbucket.s3.amazonaws.com"
      origin_id   = "sitemapBucketi"
    },
  ]


  default_cache_behavior = [
    {
      allowed_methods         = ["DELETE", "POST", "GET", "HEAD", "PATCH", "OPTIONS", "PUT"]
      cached_methods          = ["GET", "HEAD"]
      target_origin_id        = "existing_origin"
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
      target_origin_id             = "existing_origin"
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
      target_origin_id             = "existing_origin"
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
      target_origin_id        = "existing_origin"
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
        lambda_arn   = "arn:aws:lambda:us-east-1:200473192865:function:lambda-edge-for-incoming-requests:3"
      }]
    }
  ]
  custom_error_response = []
}
