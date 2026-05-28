resource "aws_s3_bucket" "terraform_state" {
  bucket = "vermeg-eks-terraform-state"

  tags = {
    Name = "${local.env}-terraform-state"
  }
}

# Enable versioning so you can see history of your state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access to the state file
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "vermeg-eks-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${local.env}-terraform-locks"
  }
}