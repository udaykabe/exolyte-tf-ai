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
# Use the following approach to run a script on the AMI
##################################################################
#user_data = "${file("${path.module}/scripts/userdata.sh")}"

##################################################################
# The following is no longer needed because of the use of the
# 'aws_eip_association' block
##################################################################
#  provisioner "local-exec" {
#    command = "aws ec2 associate-address --instance-id  ${self.spot_instance_id} --allocation-id ${data.aws_eip.by_filter.id}"
#  }

}

# Create an EBS volume
resource "aws_ebs_volume" "ebs"{
  availability_zone =  data.aws_instance.test_worker.availability_zone
  size              = 30
  tags = {
    Name        = "UAT-EBS-VOLUME"
    Environment = "UAT"
    OS          = "LINUX"
    Managed     = "IaaC"
  }
}


# Attach the EBS volume to the spot instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_spot_instance_request.test_worker.spot_instance_id
  force_detach = false
}

# To retrieve availability zone of spot instance
data "aws_instance" "test_worker" {
  instance_id = aws_spot_instance_request.test_worker.spot_instance_id
}

#device name of ebs volume retrieved
output "ebs_device_name"{
  value = aws_volume_attachment.ebs_att.device_name
}
