variable "region_1" {
    description = "The first AWS region"
    type = string
    default = "ap-south-1"  
}
variable "region_2" {
    description = "The second AWS region"
    type = string
    default = "us-west-2" 
}

variable "ami_id" {
  description = "Map of AMI IDs for EC2 instance based on region"
  type = map(string)
  default = {
    "ap-south-1" = "ami-002f6e91abff6eb96" # AMI ID for ap-south-1
    "us-west-2"  = "ami-087f352c165340ea1"  # AMI ID for us-west-2
  }
}

variable "instance_type" {
    description = "EC2-instance"
    default = "t2.micro"
  
}
variable "key_name" {
  description = "Name of the key pair"
  type = string
}
