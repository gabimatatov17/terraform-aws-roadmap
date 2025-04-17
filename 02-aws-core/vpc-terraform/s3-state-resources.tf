#### S3 Bucket for Terraform State ####
resource "aws_s3_bucket" "tf_state" {
  bucket = "gabi-terraform-state"

  tags = {
    Name        = "${var.project_name}-tf-state-bucket"
  }

  lifecycle {
    prevent_destroy = true
  }
}

#### Enable versioning for the S3 bucket ####
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#### Enable bucket versioning ####
resource "aws_s3_bucket_versioning" "tf-state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
