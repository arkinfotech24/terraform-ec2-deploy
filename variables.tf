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
