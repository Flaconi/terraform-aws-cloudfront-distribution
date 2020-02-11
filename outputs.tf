output "name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The domain name corresponding to the distribution. For example: d604721fxaaqy9.cloudfront.net"
}

output "id" {
  value       = aws_cloudfront_distribution.this.id
  description = "The identifier for the distribution. For example: EDFDVBD632BHDS5."
}
