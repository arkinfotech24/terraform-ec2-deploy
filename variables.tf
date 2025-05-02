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

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
