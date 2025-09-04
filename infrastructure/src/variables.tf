variable "environment" {
  description = "Environment to deploy. It uses this name as the path of the Kubernetes manifests"
  type        = string

  validation {
    condition     = contains(["dev"], var.environment)
    error_message = "Valid values for var: environment are (dev)."
  }
}

##############################
##### DOMAIN
##############################
variable "domain" {
  description = "Route53 Domain - Hosted Zone - to be used. This resource should be created manually and will be just used in Terraform code as a data source."
  type        = string
}

##############################
##### AWS RELATED
##############################
variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
}

##############################
##### EPHEMERAL ENVIRONMENT
##############################
variable "deploy_ephemeral_environment" {
  description = "Controls if ephemeral environment should be deployed."
  type        = bool
}

##############################
##### GITHUB CI/CD
##############################
variable "create_github_identity_provider_oidc" {
  description = "Create and IAM Identity Provider for GitHub Actions"
  type        = bool
  default     = true
}

variable "create_github_oidc_role" {
  description = "Create and IAM Role for the GitHub Actions to connect using OIDC"
  type        = bool
  default     = true
}

variable "github_repositories" {
  description = "List containing the names of the repositories that the OIDC connection can access"
  type        = list(string)
}

variable "github_organization" {
  description = "GitHub Organization (or Github Profile) that the repositories are stored"
  type        = string
}
