resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name

  tags = {
    Name = var.environment
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"

}

resource "aws_s3_bucket_policy" "allow_oai_policy" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.policy_oai.json
}


data "aws_iam_policy_document" "policy_oai" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.id_oai}"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.b.arn}/*",
    ]
  }
}

#### ------------ website

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.b.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

