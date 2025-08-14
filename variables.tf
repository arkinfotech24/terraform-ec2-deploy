variable "instance_type" {
  default = "t3.medium"
}

variable "instance_name" {
  default = "Terraform-Managed-Instance"
}

variable "vpc_id" {
  description = "The VPC ID where Account-SG exists"
  type        = string
}

variable "platform" {
  description = "Target platform to run the local-exec provisioner (windows or unix)"
  type        = string
  default     = "unix"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}
