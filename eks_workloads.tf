# Create Namespace
resource "kubernetes_namespace_v1" "this" {
  count = var.namespace["create_new"] ? 1 : 0
  metadata {
    name = var.namespace["name"]

    labels = {
      "kubernetes.io/metadata.name" = var.namespace["name"]
    }
  }
}

# Create Service Account
resource "kubernetes_service_account_v1" "this" {
  count = var.serviceaccount["create_new"] ? 1 : 0
  metadata {
    name      = var.serviceaccount["name"]
    namespace = var.namespace["name"]
  }
}

# Annotate Service Account with the IAM Role ARN
resource "kubernetes_annotations" "annotate_service_account" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = var.serviceaccount["name"]
    namespace = var.namespace["name"]
  }
  annotations = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_role.arn
  }
  
  depends_on = [
    kubernetes_namespace_v1.this[0],
    kubernetes_service_account_v1.this[0]
  ]
}