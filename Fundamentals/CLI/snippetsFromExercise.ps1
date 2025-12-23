## snippets from the exercise
$strAWSCredentialsProfileName = "myCoolProfile"

## prep'ing for AWS connectivity -- ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
Set-Item -Path Env:AWS_DEFAULT_PROFILE -Value $strAWSCredentialsProfileName

## generate a plan, output to a file (binary, proprietary format)
terraform plan -out tfplan.out

## show the previously generated plan from the given output file (which itself is not human-readable)
terraform show tfplan.out
## show plan in JSON (compressed, no whitespace), pipe to `jq` to essentially pretty-format the JSON, then redirect pretty JSON to a file
terraform show -json tfplan.out | jq > tfplan.json
## generate plan for destruction
terraform plan -destroy -out tfplan-destroy.out
## execute the destroy plan -- no prompting/confirmation! (has alias/shortcut of `terraform destroy`, which _does_ prompt for confirmation)
terraform apply tfplan-destroy.out

## flow of the "terraform mv" exercise:
<#
- created initial infrastructures with `terraform apply` for each plan
- moved resource from one state file to another with `terraform state mv -"state-out=../terraform.tfstate" aws_instance.example_new aws_instance.example_new`
- verified state shows new resource with `terraform state list`
- saw that terraform plan found the resource to found in `state` to not be in configuration files (any `.tf` files in the current directory)
    - and it planned to destroy that resource
- removed example_new resource from configuration files (commented out, then added `removed {}` block)
    - running `terraform apply` then took the resource out of state without destroying it in AWS
- verified with `terraform state list` that resource was gone from state, and with `Get-EC2Instance` that the resource still existed in AWS
- imported the resource back into state with `terraform import aws_instance.example_new i-0f592b7905ff5df52`
    - after uncommenting the resource block in configuration files, and re-commenting the `removed {}` block
- killed _original_ EC2 instance (not one from new_state plan) via Remove-EC2Instance
- used `terraform refresh` to update the state file to reflect reality (that original instance was gone)
- saw that config and state were out of sync, as subsequent `terraform plan` planned to recreate the original instance
- removed original instance resource block from configuration files (commented out), removed from outputs.tf
- ran `terraform apply` to remove outputs, had no effect on anything in AWS (as expected)
#>