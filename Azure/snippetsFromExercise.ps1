## snippets from the exercise
$strSubscriptionName = "superDev"
$oThisSubscription = Get-AzSubscription -SubscriptionName $strSubscriptionName


#region build, https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build
## set subscription
az account set --subscription $strSubscriptionName

## create a Service Principal
az ad sp create-for-rbac --display-name terraformAZTesting --role=Contributor --scopes=/subscriptions/$($oThisSubscription.Id) | ConvertFrom-Json -OutVariable oSomeSvcPrincipal
## reset Service Principal creds
az ad sp credential reset --display-name terraformAZTesting | ConvertFrom-Json -OutVariable oSomeSvcPrincipal
## or, reset via PS module cmdlets
Remove-AzADSpCredential -DisplayName $oSomeSvcPrincipal.displayName
New-AzADSpCredential -DisplayName $oSomeSvcPrincipal.displayName -EndDate (Get-Date).AddDays(1)

## set some env variables for consumption by terraform
$Env:ARM_CLIENT_ID = ($oSomeSvcPrincipal | ConvertFrom-Json).appId
$Env:ARM_CLIENT_SECRET = ($oSomeSvcPrincipal | ConvertFrom-Json).password
$Env:ARM_SUBSCRIPTION_ID = $oThisSubscription.Id
$Env:ARM_TENANT_ID = ($oSomeSvcPrincipal | ConvertFrom-Json).tenant

## do the the usual -- init, validate, plan, apply, show
terraform init
terraform validate
terraform plan
terraform apply
terraform show
terraform state list
#endregion
