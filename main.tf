provider "aws" {
  region = "us-east-1"
}

# This resource will FAIL the scan because encryption and public access blocks are missing
resource "aws_s3_bucket" "company_data" {
  bucket        = "corporate-intel-storage-bucket-2026"
  force_destroy = true
}

