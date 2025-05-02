variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "Terraform-SSM-Instance"
}

variable "vpc_id" {
  description = "The VPC ID where Account-SG exists"
  type        = string
}
