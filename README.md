# Terraform AWS Cloudfront distribution module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.57 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.57 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Default Cache Behviors to be used in dynamic block | `any` | n/a | yes |
| <a name="input_iam_certificate_id"></a> [iam\_certificate\_id](#input\_iam\_certificate\_id) | Specifies IAM certificate id for CloudFront distribution | `string` | n/a | yes |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. One of SSLv3, TLSv1, TLSv1\_2016, TLSv1.1\_2016 or TLSv1.2\_2018. Default: TLSv1. NOTE: If you are using a custom certificate (specified with acm\_certificate\_arn or iam\_certificate\_id), and have specified sni-only in ssl\_support\_method, TLSv1 or later must be specified. If you have specified vip in ssl\_support\_method, only SSLv3 or TLSv1 can be specified. If you have specified cloudfront\_default\_certificate, TLSv1 must be specified. | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Aliases, or CNAMES, for the distribution | `list(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comment about the CloudFront Distribution | `string` | `""` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | Custom error response to be used in dynamic block | <pre>list(object({<br>      error_caching_min_ttl = number<br>      error_code            = number<br>      response_code         = number<br>      response_page_path    = string<br>  }))</pre> | `[]` | no |
| <a name="input_custom_origin_config"></a> [custom\_origin\_config](#input\_custom\_origin\_config) | Configuration for the custom origin config to be used in dynamic block | `any` | `[]` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL | `string` | `""` | no |
| <a name="input_dynamic_s3_origin_config"></a> [dynamic\_s3\_origin\_config](#input\_dynamic\_s3\_origin\_config) | Configuration for the s3 origin config to be used in dynamic block | `list(map(string))` | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content | `bool` | `true` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | The restriction type of your CloudFront distribution geolocation restriction. Options include none, whitelist, blacklist | <pre>object({<br>    restriction_type = string<br>    locations        = list(string)<br>  })</pre> | `null` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2 | `string` | `"http2"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution | `bool` | `true` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | This is the logging configuration for the Cloudfront Distribution.  It is not required.<br>    If you choose to use this configuration, be sure you have the correct IAM and Bucket ACL<br>    rules.  Your tfvars file should follow this syntax:<br><br>    logging\_config = {<br>      bucket = "<your-bucket>"<br>      include\_cookies = <true or false><br>      prefix = "<your-bucket-prefix>"<br>    } | `map(any)` | `{}` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | Ordered Cache Behaviors to be used in dynamic block | `any` | `[]` | no |
| <a name="input_origin_groups"></a> [origin\_groups](#input\_origin\_groups) | Origin Group to be used in dynamic block | `any` | `[]` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class of the CloudFront Distribution.  Valid types are PriceClass\_All, PriceClass\_100, PriceClass\_200 | `string` | `"PriceClass_100"` | no |
| <a name="input_region"></a> [region](#input\_region) | Target AWS region | `string` | `"us-east-1"` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| <a name="input_s3_origin_config"></a> [s3\_origin\_config](#input\_s3\_origin\_config) | Configuration for the custom origin config to be used in dynamic block | `any` | `[]` | no |
| <a name="input_ssl_support_method"></a> [ssl\_support\_method](#input\_ssl\_support\_method) | Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. | `string` | `"sni-only"` | no |
| <a name="input_tag_name"></a> [tag\_name](#input\_tag\_name) | The tagged name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of custom tags for the provisioned resources | `map(string)` | `{}` | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. | `bool` | `true` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | The WAF Web ACL | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The identifier for the distribution. For example: EDFDVBD632BHDS5. |
| <a name="output_name"></a> [name](#output\_name) | The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
