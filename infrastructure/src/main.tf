##############################
##### CERTIFICATE
##############################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name       = var.domain
  validation_method = "DNS"
  zone_id           = data.aws_route53_zone.this.id

  subject_alternative_names = [
    "${var.environment}.${var.domain}",
  ]
  wait_for_validation = true

  providers = {
    aws = aws.us_east_1
  }
}

##############################
##### FRONTEND
##############################
module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "5.0.0"

  aliases             = ["${var.environment}.${var.domain}"]
  comment             = "CDN of Frontend"
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    "oac-${local.project}" = {
      description      = "Frontend assets bucket"
      origin_type      = "s3"
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
  origin = {
    s3 = {
      domain_name           = "${local.frontend_bucket_name}.s3.us-east-1.amazonaws.com"
      origin_access_control = "oac-${local.project}"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized - Recommended for S3
    use_forwarded_values   = false
    compress               = true
  }

  viewer_certificate = {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.7.0"

  bucket = local.frontend_bucket_name

  attach_policy = true
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${local.frontend_bucket_name}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "arn:aws:cloudfront::${local.account_id}:distribution/${module.cdn.cloudfront_distribution_id}"
          }
        }
      }
    ]
  })

  providers = {
    aws = aws.us_east_1
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "5.0.0"

  zone_name = data.aws_route53_zone.this.name

  records = [
    {
      name = var.environment
      type = "A"
      alias = {
        name    = module.cdn.cloudfront_distribution_domain_name
        zone_id = module.cdn.cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}


##############################
##### FRONTEND - EPHEMERAL ENVIRONMENT
##############################
module "acm_ephemeral" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name       = var.domain
  validation_method = "DNS"
  zone_id           = data.aws_route53_zone.this.id

  subject_alternative_names = [
    "*.ephemeral.${var.domain}",
  ]
  wait_for_validation = true

  providers = {
    aws = aws.us_east_1
  }
}

module "cdn_ephemeral" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "5.0.0"
  count   = var.deploy_ephemeral_environment ? 1 : 0


  aliases             = ["*.ephemeral.${var.domain}"]
  comment             = "CDN of Frontend for Ephemeral Environments"
  price_class         = "PriceClass_All"
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    "oac-${local.project}-ephemeral" = {
      description      = "Frontend assets bucket - Ephemeral"
      origin_type      = "s3"
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
  origin = {
    s3 = {
      domain_name           = "${local.frontend_ephemeral_bucket_name}.s3.us-east-1.amazonaws.com"
      origin_access_control = "oac-${local.project}-ephemeral"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized - Recommended for S3
    use_forwarded_values   = false
    compress               = true

    lambda_function_association = {
      viewer-request = {
        lambda_arn   = module.lambda_function[0].lambda_function_qualified_arn
        include_body = true
      }
    }
  }

  viewer_certificate = {
    acm_certificate_arn      = module.acm_ephemeral.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.1.0"
  count   = var.deploy_ephemeral_environment ? 1 : 0

  function_name = "ephemeral-frontend"
  description   = "My awesome lambda function"
  handler       = "index.handler"
  runtime       = "nodejs22.x"

  publish        = true
  lambda_at_edge = true

  timeout     = 3
  source_path = "${path.module}/lambda/ephemeral-frontend"

  providers = {
    aws = aws.us_east_1
  }
}

module "records_ephemeral" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "5.0.0"
  count   = var.deploy_ephemeral_environment ? 1 : 0

  zone_name = data.aws_route53_zone.this.name

  records = [
    {
      name = "*.ephemeral.${var.environment}"
      type = "A"
      alias = {
        name    = module.cdn_ephemeral[0].cloudfront_distribution_domain_name
        zone_id = module.cdn_ephemeral[0].cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}

module "s3_bucket_ephemeral" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.7.0"
  count   = var.deploy_ephemeral_environment ? 1 : 0

  bucket = local.frontend_ephemeral_bucket_name

  attach_policy = true
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${local.frontend_ephemeral_bucket_name}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "arn:aws:cloudfront::${local.account_id}:distribution/${module.cdn_ephemeral[0].cloudfront_distribution_id}"
          }
        }
      }
    ]
  })

  providers = {
    aws = aws.us_east_1
  }
}
