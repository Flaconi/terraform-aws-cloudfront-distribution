output "name" {
  value       = try(aws_cloudfront_distribution.this[0].domain_name, "")
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net"
}

output "id" {
  value       = try(aws_cloudfront_distribution.this[0].id, "")
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
}
