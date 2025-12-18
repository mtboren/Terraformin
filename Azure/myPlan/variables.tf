variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myTFResourceGroup"
}

variable "az_region" {
  description = "The Azure region to which to deploy resources"
  type        = string
  default     = "northcentralus"
}