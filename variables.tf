variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "web-ec2-ssm"
}


#variable "instance_type" {
#  default = "t3.medium"
#}

#variable "instance_name" {
#  default = "Terraform-Managed-Instance"
#}

#variable "vpc_id" {
#  description = "The VPC ID where Account-SG exists"
#  type        = string
#}


