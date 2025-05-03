# provider.tf
provider "aws" {
  region = "us-east-1"
}

# DO NOT use variables for AWS credentials in Terraform configs.
# Instead, configure AWS credentials via environment variables, e.g.,
# export AWS_ACCESS_KEY_ID=your_key
# export AWS_SECRET_ACCESS_KEY=your_secret

# variables.tf
variable "instance_type" {
  default = "t3.micro"
}

variable "instance_name" {
  default = "ssm-ec2-instance"
}

variable "vpc_id" {
  description = "The VPC ID where Account-SG exists"
  type        = string
}

# Lookup Existing Security Group

data "aws_security_group" "account_sg" {
  filter {
    name   = "group-name"
    values = ["Account-SG"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# IAM Role and Instance Profile
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

# Get Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Launch EC2 Instance
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = "alreliance-key"
  subnet_id                   = "subnet-9a5ab4d7"
  vpc_security_group_ids      = [data.aws_security_group.account_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
            EOF

  tags = {
    Name = var.instance_name
  }
}

# outputs.tf
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "ssm_profile" {
  value = aws_iam_instance_profile.ssm_profile.name
}

