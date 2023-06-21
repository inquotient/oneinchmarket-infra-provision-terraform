provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_files  = ["/home/ahnjisoo/.aws/credentials"]
    profile = "default"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = lower("${var.appname}-bucket")

  control_object_ownership = true

  versioning = {
    enabled = true
  }
}

# resource "aws_s3_access_point" "s3_access_point" {
#   bucket = module.s3_bucket.s3_bucket_id
#   name   = lower(var.appname)
# 
#   vpc_configuration {
#     vpc_id = var.vpc_id
#   }
# }

# TODO: kops 설치 시에 kops aws 계정권한 설정할 것
# resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#  bucket = module.s3_bucket.s3_bucket_id
#  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
# }

# data "aws_iam_policy_document" "allow_access_from_another_account" {
#  statement {
#    principals {
#      type        = "AWS"
#      identifiers = ["123456789012"]
#    }
#
#    actions = [
#      "s3:GetObject",
#      "s3:ListBucket",
#    ]
#
#    resources = [
#      aws_s3_bucket.example.arn,
#      "${aws_s3_bucket.example.arn}/*",
#    ]
#  }
# }