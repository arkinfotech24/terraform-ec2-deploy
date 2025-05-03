provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = "us-east-1"
}

# -----------------------------
# Lookup Existing Security Group in VPC
# -----------------------------
data "aws_security_group" "account_sg" {
  filter {
    name   = "group-name"
    values = ["Account-SG"]
  }

  filter {
    name   = "vpc-id"
    values = ["vpc-bd543ec7"]
  }
}

# -----------------------------
# IAM Role, Policy, and Instance Profile for SSM
# -----------------------------
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
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

# -----------------------------
# Get Latest Amazon Linux 2023 AMI
# -----------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# -----------------------------
# EC2 Instance with SSM and SSH Access
# -----------------------------
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = "alreliance-key"  # Use existing key
  subnet_id                   = "subnet-9a5ab4d7"  # Use existing subnet
  vpc_security_group_ids      = [data.aws_security_group.account_sg.id]  # Use existing SG
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              cd /tmp
              sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
            EOF

  tags = {
    Name = var.instance_name
  }
}

# -----------------------------
# Outputs
# -----------------------------
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
