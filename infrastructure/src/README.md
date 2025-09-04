# src

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 5.1.1 |
| <a name="module_acm_ephemeral"></a> [acm\_ephemeral](#module\_acm\_ephemeral) | terraform-aws-modules/acm/aws | 5.1.1 |
| <a name="module_cdn"></a> [cdn](#module\_cdn) | terraform-aws-modules/cloudfront/aws | 5.0.0 |
| <a name="module_cdn_ephemeral"></a> [cdn\_ephemeral](#module\_cdn\_ephemeral) | terraform-aws-modules/cloudfront/aws | 5.0.0 |
| <a name="module_iam_github_oidc_provider"></a> [iam\_github\_oidc\_provider](#module\_iam\_github\_oidc\_provider) | terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider | v5.55.0 |
| <a name="module_iam_github_oidc_role"></a> [iam\_github\_oidc\_role](#module\_iam\_github\_oidc\_role) | terraform-aws-modules/iam/aws//modules/iam-github-oidc-role | v5.55.0 |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | 8.1.0 |
| <a name="module_records"></a> [records](#module\_records) | terraform-aws-modules/route53/aws//modules/records | 5.0.0 |
| <a name="module_records_ephemeral"></a> [records\_ephemeral](#module\_records\_ephemeral) | terraform-aws-modules/route53/aws//modules/records | 5.0.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.7.0 |
| <a name="module_s3_bucket_ephemeral"></a> [s3\_bucket\_ephemeral](#module\_s3\_bucket\_ephemeral) | terraform-aws-modules/s3-bucket/aws | 5.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy resources | `string` | n/a | yes |
| <a name="input_create_github_identity_provider_oidc"></a> [create\_github\_identity\_provider\_oidc](#input\_create\_github\_identity\_provider\_oidc) | Create and IAM Identity Provider for GitHub Actions | `bool` | `true` | no |
| <a name="input_create_github_oidc_role"></a> [create\_github\_oidc\_role](#input\_create\_github\_oidc\_role) | Create and IAM Role for the GitHub Actions to connect using OIDC | `bool` | `true` | no |
| <a name="input_deploy_ephemeral_environment"></a> [deploy\_ephemeral\_environment](#input\_deploy\_ephemeral\_environment) | Controls if ephemeral environment should be deployed. | `bool` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Route53 Domain - Hosted Zone - to be used. This resource should be created manually and will be just used in Terraform code as a data source. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to deploy. It uses this name as the path of the Kubernetes manifests | `string` | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub Organization (or Github Profile) that the repositories are stored | `string` | n/a | yes |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | List containing the names of the repositories that the OIDC connection can access | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
