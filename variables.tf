variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = null
}

variable "oidc_provider_arn"{
  description = "ARN of the EKS OIDC Provider"
  type        = string
  default     = null
}


variable "irsa_role_name" {
  description = "Name of the irsa role"
  type        = string
  default     = null
}

variable "namespace" {
  description = "Existing namespace name"
  type        = string
  default     = "kube-system"
}

variable "serviceaccount" {
  description = "Existing service account name"
  type        = string
  default     = null
}

variable "iam_policy_arn" {
  description = "ARN of the IAM Policy to be attached"
  type        = string
  default     = null
}