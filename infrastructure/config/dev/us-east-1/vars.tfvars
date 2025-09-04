environment = "dev"
aws_region  = "us-east-1"
domain      = "demosfelipetrindade.lat"

deploy_ephemeral_environment = true

create_github_identity_provider_oidc = false # I have this already deployed in my account
create_github_oidc_role              = true
github_repositories                  = ["ephemeral-environment-frontend"]
github_organization                  = "felipelaptrin"
