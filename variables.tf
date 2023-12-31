variable "create" {
  description = "Enable or Disable IRSA"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = null
}

variable "oidc_provider_arn" {
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
  description = "Enter Namespace"
  type        = map(any)
  default = {
    create_new = false,
    name       = null
  }
}

variable "serviceaccount" {
  description = "Enter service account name"
  type        = map(any)
  default = {
    create_new = false,
    name       = null
  }
}

variable "iam_policy_arn" {
  description = "ARN of the IAM Policy to be attached"
  type        = string
  default     = null
}