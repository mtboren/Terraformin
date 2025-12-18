## snippets from the exercise
$strSubscriptionName = "superDev"
$oThisSubscription = Get-AzSubscription -SubscriptionName $strSubscriptionName
$strServicePrincipalDisplayName = "terraformAZTesting"


#region build, https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build
## set subscription
az account set --subscription $strSubscriptionName

## create a Service Principal
az ad sp create-for-rbac --display-name $strServicePrincipalDisplayName --role=Contributor --scopes=/subscriptions/$($oThisSubscription.Id) | ConvertFrom-Json -OutVariable oSomeSvcPrincipalCred
## reset Service Principal creds
az ad sp credential reset --id (Get-AzADServicePrincipal -DisplayName $strServicePrincipalDisplayName).Id | ConvertFrom-Json -OutVariable oSomeSvcPrincipalCred
## or, reset via PS module cmdlets
Remove-AzADSpCredential -DisplayName $strServicePrincipalDisplayName
Get-AzADServicePrincipal -DisplayName $strServicePrincipalDisplayName -OutVariable oThisADSvcPrincipal | New-AzADSpCredential -EndDate (Get-Date).AddDays(1) -OutVariable oSomeSvcPrincipalCred

## set some env variables for consumption by terraform
$Env:ARM_CLIENT_ID = $oSomeSvcPrincipalCred.appId
$Env:ARM_CLIENT_SECRET = $oSomeSvcPrincipalCred.password
$Env:ARM_SUBSCRIPTION_ID = $oThisSubscription.Id
$Env:ARM_TENANT_ID = $oSomeSvcPrincipalCred.tenant
## or, when using PS modules
# $Env:ARM_CLIENT_ID = $oThisADSvcPrincipal.AppId
# $Env:ARM_CLIENT_SECRET = $oSomeSvcPrincipalCred.SecretText
# $Env:ARM_SUBSCRIPTION_ID = $oThisSubscription.Id
# $Env:ARM_TENANT_ID = $oThisADSvcPrincipal.AppOwnerOrganizationId

## do the the usual -- init, validate, plan, apply, show
terraform init
terraform validate
terraform plan
terraform apply
terraform show
terraform state list
#endregion


#region variables things, https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-variables
## override variables via CLI
terraform apply -var "resource_group_name=myShtRG"
#endregion


## destroy!
terraform destroy