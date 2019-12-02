# This code was adapted from the `terraform-aws-cloudfront` module from Jonathan Greg
# Available here: https://github.com/jmgreg31/terraform-aws-cloudfront
#

resource "aws_cloudfront_distribution" "this" {
  aliases             = var.aliases
  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id

  dynamic "origin" {
    for_each = { for origin in var.custom_origin_config : origin.origin_id => origin }

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = lookup(origin.value, "origin_path", null)
      custom_origin_config {
        http_port                = origin.value.http_port
        https_port               = origin.value.https_port
        origin_keepalive_timeout = origin.value.origin_keepalive_timeout
        origin_read_timeout      = origin.value.origin_read_timeout
        origin_protocol_policy   = origin.value.origin_protocol_policy
        origin_ssl_protocols     = origin.value.origin_ssl_protocols
      }
    }
  }

  dynamic "origin" {
    for_each = { for origin in var.s3_origin_config : origin.origin_id => origin }

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = lookup(origin.value, "origin_path", null)
      dynamic "s3_origin_config" {
        for_each = { for enabled in [1] : enabled => enabled if lookup(origin.value, "origin_access_identity", null) != null }
        content {
          origin_access_identity = lookup(origin.value, "origin_access_identity", null)
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = { for origingroup in var.origin_groups : origingroup.origin_id => origingroup }
    content {
      origin_id = origin_group.value.origin_id
      failover_criteria {
        status_codes = origin_group.value.status_codes
      }

      dynamic "member" {
        for_each = origin_group.value.members
        content {
          origin_id = member.value
        }
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = { for i in var.default_cache_behavior : i.target_origin_id => i }
    content {
      allowed_methods  = default_cache_behavior.value.allowed_methods
      cached_methods   = default_cache_behavior.value.cached_methods
      target_origin_id = default_cache_behavior.value.target_origin_id
      compress         = default_cache_behavior.value.compress

      forwarded_values {
        query_string = default_cache_behavior.value.query_string
        cookies {
          forward = default_cache_behavior.value.cookies_forward
        }
        headers = default_cache_behavior.value.headers
      }
      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = default_cache_behavior.value.min_ttl
      default_ttl            = default_cache_behavior.value.default_ttl
      max_ttl                = default_cache_behavior.value.max_ttl
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = { for i in var.ordered_cache_behavior : i.path_pattern => i }
    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id
      compress         = ordered_cache_behavior.value.compress

      forwarded_values {
        query_string            = ordered_cache_behavior.value.query_string
        query_string_cache_keys = lookup(ordered_cache_behavior.value, "query_string_cache_keys", [])
        cookies {
          forward           = ordered_cache_behavior.value.cookies_forward
          whitelisted_names = lookup(ordered_cache_behavior.value, "whitelisted_names", null)
        }
        headers = ordered_cache_behavior.value.headers
      }
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      dynamic "lambda_function_association" {
        for_each = lookup(ordered_cache_behavior.value, "lambda_function_associations")
        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = { for i in var.custom_error_response : i.error_code => i }
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  #dynamic "logging_config" {
  #  for_each = var.logging_config[*]
  #  content {
  #    bucket          = lookup(logging_config.value,"bucket",null)
  #    include_cookies = lookup(logging_config.value,"include_cookies",null)
  #    prefix          = lookup(logging_config.value,"prefix",null)
  #  }
  #}

  tags = var.tags

  dynamic "restrictions" {
    for_each = var.geo_restriction[*]
    content {
      dynamic "geo_restriction" {
        for_each = var.geo_restriction[*]
        content {
          locations        = geo_restriction.value.locations
          restriction_type = geo_restriction.value.restriction_type
        }
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    iam_certificate_id             = var.iam_certificate_id == "" ? var.iam_certificate_id : null
    minimum_protocol_version       = var.minimum_protocol_version == "" ? var.minimum_protocol_version : null
    ssl_support_method             = var.ssl_support_method == "" ? var.ssl_support_method : null
  }
}
