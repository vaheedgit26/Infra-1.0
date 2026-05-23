#resource "random_string" "suffix" {
#  length  = 6
#  upper   = false
#  special = false
#}

resource "aws_s3_bucket" "bucket" {
  # bucket = "${var.s3_bucket_name}-${random_string.suffix.result}"

  bucket = var.s3_bucket_name
  force_destroy = true   # will be deleted forcefully

  lifecycle {
    prevent_destroy = false
  }
  
  tags = merge(
    var.common_tags,
    { 
      Name    = var.s3_bucket_name 
      Purpose = "terraform-backend"
    }
  )

}

# This will incur some cost
#resource "aws_s3_bucket_versioning" "bucket_versioning" {
#  bucket = aws_s3_bucket.bucket.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
