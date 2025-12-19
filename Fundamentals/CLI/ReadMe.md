# Terraformin — CLI

This project, focused on Terraform CLI, follows the HashiCorp tutorial [Use the Command Line Interface
](https://developer.hashicorp.com/terraform/tutorials/cli).

### Purpose
- **Learning:**: Hands-on practice with Terraform CLI fundamentals

Some key topics:
- `terraform init` and upgrading modules/providers after first init
- `terraform validate` again after `init -upgrade`, to ensure usage is still correct (no breaking changes from upgrade)
- `terraform plan` for creating the plan, but not yet applying any changes; useful for inspecting proposed changes; somewhat similar to an AWS CloudFormation changeset
    - **Note**: per the guide, _Terraform plan files can contain sensitive data. Never commit a plan file to version control, whether as a binary or in JSON format_
- use of `*.tfvars` files for temporary, local variables; in `key = "value"` format, per line
    - **Note**: per the guide, _Never commit .tfvars files to version control_
- `terraform apply` for actually applying plan