provider "aws" {
  region = "us-east-1"
}

# Target core infrastructure storage
resource "aws_s3_bucket" "company_data" {
  bucket        = "corporate-intel-storage-bucket-2026"
  force_destroy = true
}

# FIX 1: Prevent any future public sharing exposure
resource "aws_s3_bucket_public_access_block" "company_data_privacy" {
  bucket                  = aws_s3_bucket.company_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# FIX 2: Ensure all stored objects are encrypted at rest automatically
resource "aws_s3_bucket_server_side_encryption_configuration" "company_data_crypto" {
  bucket = aws_s3_bucket.company_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


