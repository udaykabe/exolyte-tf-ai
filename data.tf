data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ec2_spot_price" "get_spot_price" {
  instance_type     = var.type
  availability_zone = "us-east-1a"

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}

#############################################################
# Default VPC, SG, and IG.  Pre-allocated Public IP
#############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_eip" "by_filter" {
  filter {
    name   = "tag:Name"
    values = ["exoPubIPV4"]
  }
}

data "aws_iam_instance_profile" "ssm_profile" {
  name = "AmazonSSMRoleForInstancesQuickSetup"
}
