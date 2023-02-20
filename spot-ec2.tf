# Provisions an EC2 spot instance
# Zone for AMI is us-east-1a

provider "aws" {
  region = var.awsprops["region"]
}

resource "aws_spot_instance_request" "test_worker" {
  ami           = var.ami
  instance_type = var.type
  spot_price    = var.spot_instance_props["spot_price"]
  spot_type     = var.spot_instance_props["spot_type"]
  key_name      = var.awsprops["keyname"]
  iam_instance_profile = data.aws_iam_instance_profile.ssm_profile.name

  wait_for_fulfillment = true

  vpc_security_group_ids = [
    aws_security_group.ssh-uat.id,
    aws_security_group.http-uat.id,
    aws_security_group.https-uat.id
  ]

  subnet_id = aws_subnet.subnet-uat.id

  # This provisioner uses the check-instance_state to ensure the instance
  # status is in an "ok" state, otherwise the EIP association will fail
  provisioner "local-exec" {
    command = "${path.module}/scripts/check-instance-state.sh ${self.spot_instance_id}"
  }

  tags = {
    Name        = "UAT-SERVER"
    Environment = "UAT"
    OS          = "LINUX"
    Managed     = "IaaC"
  }

##################################################################
# The following is no longer needed because of the use of the
# 'aws_eip_association' block
##################################################################
#  provisioner "local-exec" {
#    command = "aws ec2 associate-address --instance-id  ${self.spot_instance_id} --allocation-id ${data.aws_eip.by_filter.id}"
#  }
}
