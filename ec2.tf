# --- DEPENDENCY: Basic Secure IAM Role & Profile for the Server (Fixes CKV2_AWS_41) ---
resource "aws_iam_role" "app_role" {
  name = "corporate-ec2-application-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "://amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "corporate-ec2-instance-profile"
  role = aws_iam_role.app_role.name
}

# --- MAIN COMPUTE RESOURCE ---
resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.medium"

  # FIX FOR CKV2_AWS_41: Attach the IAM profile to the compute layer
  iam_instance_profile = aws_iam_instance_profile.app_profile.name

  # FIX FOR CKV_AWS_135: Force dedicated storage throughput bandwidth
  ebs_optimized = true

  # FIX FOR CKV_AWS_126: Shrink CloudWatch tracking frequency down to 1 minute
  monitoring = true

  root_block_device {
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "Corporate-App-Server"
    Environment = "Production"
  }
}

