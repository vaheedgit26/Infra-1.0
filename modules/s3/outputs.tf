output "bucket_arn" {
  description = "ARN of the Terraform remote state S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "bucket_id" {
  description = "Bucket ID (same as name) for Terraform state"
  value       = aws_s3_bucket.bucket.id
}
