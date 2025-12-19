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
