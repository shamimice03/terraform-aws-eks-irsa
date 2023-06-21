variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "irsa_role_name" {
  description = "Name of the irsa role"
  type        = string
  default     = "S3ReadAccessIRSA"
}

variable "namespace" {
  description = "Existing namespace name"
  type        = string
  default     = "dev-ns"
}

variable "serviceaccount" {
  description = "Existing service account name"
  type        = string
  default     = "aws-access"
}