resource "aws_s3_bucket" "s3" {
  bucket = local.s3_name

  tags = {
    Name        = "static-project"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "s32" {
  bucket = local.s3_name2

  tags = {
    Name        = "static-project"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "l1" {
  bucket = local.s3_name
  rule {
    status = "Enabled"
    id     = "expire_all_files"
    expiration {
        days = 90
    }
        filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }
  }

}

 resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
   bucket = local.s3_name2

   rule {
     id = "images"
     status = "Enabled"

     transition {
       days          = 90
       storage_class = "GLACIER"
     }
   }

 }