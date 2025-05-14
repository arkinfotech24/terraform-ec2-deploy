provider "aws" {
  region = "us-east-1"
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
# **Delete Existing IAM Role If Found**
# -----------------------------
resource "null_resource" "delete_existing_role" {
  provisioner "local-exec" {
    command = <<EOT
      set ROLE_NAME=SSM-EC2Role
      aws iam get-role --role-name %ROLE_NAME% >nul 2>&1
      if %ERRORLEVEL% EQU 0 (
        echo ⚠️ Role %ROLE_NAME% exists. Deleting before Terraform Apply...
        aws iam detach-role-policy --role-name %ROLE_NAME% --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
        aws iam delete-role --role-name %ROLE_NAME%
      ) else (
        echo ✅ Role %ROLE_NAME% not found. Continuing...
      )
    EOT
    interpreter = ["cmd.exe", "/C"]
  }
}

# -----------------------------
# **New IAM Role, Policy, and Instance Profile for SSM**
# -----------------------------
resource "aws_iam_role" "new_ssm_role" {
  name       = "SSM-EC2Role"
  depends_on = [null_resource.delete_existing_role]

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "new_ssm_attach" {
  role       = aws_iam_role.new_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "new_ssm_profile" {
  name = "new-ec2-ssm-profile"
  role = aws_iam_role.new_ssm_role.name

  lifecycle {
    create_before_destroy = true
  }
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
  key_name                    = "alreliance-key"
  subnet_id                   = "subnet-9a5ab4d7"
  vpc_security_group_ids      = [data.aws_security_group.account_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.new_ssm_profile.name

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
