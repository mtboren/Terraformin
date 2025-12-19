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
    - **Note**: per the guide, _Never commit .tfvars files to version control_ -- this might apply only to vars files with sensitive data in them; one practice is to make `terraform.tfvars.example` file with dummy values, for others' info
- `terraform apply` for actually applying plan
    - > Use the `-replace` argument when a resource has become unhealthy or stops working in ways that are outside of Terraform's control
- `terraform state list` to show resources in the config
- Variables declarations:
    - > ...can appear anywhere in your configuration files. However, we recommend putting them into a separate file called variables.tf to make it easier for users to understand how they can customize the configuration
    - > ...must be literal values, and cannot use computed values like resource attributes, expressions, or other variables
    - can use functions to interact with variable values; for example: `slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)` to get just some count of values from the list
    - can override (or specify values for vars that have no default) via the `-var` commandline parameter
    - can include "validation" on variable values via `validation` property in variable declaration; somewhat like constraints in CloudFormation template parameters
- `terraform console` opens an interactive console with which to evaluate expressions in the context of your configuration
- Interpolate variables in strings:  Terraform configuration supports string interpolation, using `${var.blahh}` syntax; can use variables, local values, and the output of functions to create such strings
