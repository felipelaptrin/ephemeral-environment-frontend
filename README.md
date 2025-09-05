# Ephemeral Environment for Frontend

This is a demo repository for my [blog post](https://www.felipetrindade.com/ephemeral-environment-frontend/).

## How to run this project

1) Install dev dependencies with Devbox

```sh
devbox shell
```

2) Initilize Terraform

```sh
cd infrastructure/src
terraform init --backend-config=../config/dev/us-east-1/backend.hcl
```

:warning: Modify the file `infrastructure/config/dev/us-east-1/backend.hcl` with appropriate values that fit your needs.
:warning: Make sure AWS credentials are present in your terminal

3) Deploy infrastructure

```sh
terraform apply --var-file=../config/dev/us-east-1/vars.tfvars
```

:warning: Modify the file `infrastructure/config/dev/us-east-1/vars.tfvars` with appropriate values that fit your needs.

4) Set env vars for the GitHub Actions Workflow

Modify the `.github/workflows/ephemeral.yaml` and `.github/workflows/frontend.yaml` files (the `env` section) with proper values and enjoy your ephemeral environment for frontend!