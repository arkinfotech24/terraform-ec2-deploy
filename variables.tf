variable "instance_type" {
  default = "t2.micro"
}

variables "aws_secret" {
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

}

variable "instance_name" {
  default = "Terraform-Managed-Instance"
}

variable "vpc_id" {
  description = "The VPC ID where Account-SG exists"
  type        = string
}
