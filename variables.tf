variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "instance_name" {
  default = "TerraformEC2"
}

variable "key_name" {
  default = "terraform-key"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
