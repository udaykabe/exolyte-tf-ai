variable "app_name" {
  description = "Application name"
  default     = "exoChatGPT"
}

variable "ami" {
  type        = string
  description = "AMI ID of EC2 ECS instance"
  default     = "ami-02f6e3cd6f1b8d2cc"

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
    ami          = "ami-0c1bea58988a989155"
    itype        = "t2.micro"
    subnet       = "subnet-81896c8e"
    publicip     = true
    keyname      = "spot_key"
    secgroupname = "IAC-Sec-Group"
  }
}
