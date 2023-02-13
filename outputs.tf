output "most_recent_spot_price" {
  value       = data.aws_ec2_spot_price.get_spot_price.spot_price
  description = "Most Recent Spot Price"
}

output "elastic_ip" {
  value       = aws_spot_instance_request.test_worker.public_ip
  description = "The assigned elastic IP"
}

output "default_vpc" {
  value       = data.aws_vpc.default.id
  description = "The default VPC"
}

output "default_sg" {
  value       = data.aws_security_group.default.id
  description = "The default security group for the default VPC"
}

output "default_gw" {
  value       = data.aws_internet_gateway.default.id
  description = "The default VPC"
}

output "reserved_ip" {
  value       = data.aws_eip.by_filter.id
  description = "The assigned elastic IP"
}

output "ssm_instance_profile" {
  value       = data.aws_iam_instance_profile.ssm_profile.arn
  description = "The SSM Instance Profile ARN"
}

output "spot_instance_id" {
  value       = aws_spot_instance_request.test_worker.spot_instance_id
  description = "The Spot Instance ID"
}
