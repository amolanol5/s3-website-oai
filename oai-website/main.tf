provider "aws" {
  region = "us-east-1"
  profile = "default"
}


module "s3_bucket_b" {
  source  = "../modules/s3website-oai"
  id_oai = "E3VVRELYA9KBJZ"
  bucket_name = "website-2022-oai-amolanol"

}

output "domain_name_bucket" {
  value = module.s3_bucket_b.bucket_regional_domain_name
}

module "cloudfront_oai" {
  source  = "../modules/cloudfront"

  id_oai_cloudfront = "E3VVRELYA9KBJZ"
  id_origin = "origin-s3-website-oai"
  bucket_regional_domain_name = module.s3_bucket_b.bucket_regional_domain_name

}