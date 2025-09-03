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
