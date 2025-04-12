provider aws {
    region = var.aws_region
}

# S3 Bucket
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = var.bucket_name

    tags = {
        Name        = var.bucket_name
        Environment = "dev"
    }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "my_s3_bucket_policy" {
    bucket = aws_s3_bucket.my_s3_bucket.id
    policy = templatefile("${path.module}/my_bucket_policy.json", {
        bucket_name = var.bucket_name
    })

    # policy = jsonencode({
    #     Version = "2012-10-17"
    #     Statement = [
    #         {
    #             Effect = "Allow"
    #             Principal = "*"
    #             Action = "s3:GetObject"
    #             Resource = "${aws_s3_bucket.my_s3_bucket.arn}/*"
    #         }
    #     ]
    # })
}