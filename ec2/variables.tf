variable "app_name" {
  description = "Application name"
  default     = "exoChatGPT"
}

# Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
variable "ami" {
  type        = string
  description = "AMI ID of EC2 ECS instance"
  default     = "ami-00b8917ae86a424c9" # (64-bit (x86))

  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "Please provide a valid AMI ID."
  }
}

variable "type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "tags" {
  type = object({
    name = string
    env  = string
  })
  description = "Tags for the EC2 instance"
  default = {
    name = "User Acceptance Test"
    env  = "UAT"
  }
}

variable "cidr_block" {
  description = "cidr subnet for the app"
  default     = "10.0.0.0/16"
}

variable "spot_instance_props" {
  type = map(string)
  default = {
    spot_price = "0.0116"
    spot_type  = "one-time"
  }
}

# placeholder
variable "awsprops" {
  type = map(string)
  default = {
    region       = "us-east-1"
    vpc          = "vpc-5234832d"
    ami          = "ami-079db87dc4c10ac91" # Amazon Linux 2023 AMI (64-bit (x86), uefi-preferred)
    itype        = "t2.micro"
    subnet       = "subnet-81896c8e"
    publicip     = true
    keyname      = "spot_key"
    secgroupname = "IAC-Sec-Group"
  }
}

