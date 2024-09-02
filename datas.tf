data "aws_default_tags" "this" {}

data "aws_kms_key" "this" {
  count  = try(var.kms_key_id ? 1 : 0)
  key_id = try(var.kms_key_id)
}

data "aws_s3_bucket" "this" {
  count = try(var.aws_s3_bucket ? 1 : 0)
  bucket = try(var.aws_s3_bucket)
}