resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.medium" # Has a fixed monthly runtime cost for Infracost

  # Secure root block configuration to pass Checkov audits
  root_block_device {
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Enforces IMDSv2 security protocol
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "Corporate-App-Server"
    Environment = "Production"
  }
}

