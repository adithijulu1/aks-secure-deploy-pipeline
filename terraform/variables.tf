variable "resource_group_name" {
  description = "Resource group for AKS deployment resources"
  type        = string
  default     = "aks-deploy-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "secure-deploy-aks"
}

variable "key_vault_name" {
  description = "Name of the Key Vault for app secrets"
  type        = string
  default     = "secure-deploy-kv"
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "admin_group_object_ids" {
  description = "Entra ID group object IDs with AKS admin access"
  type        = list(string)
  default     = []
}
