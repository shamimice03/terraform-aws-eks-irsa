locals {
  // sample arn: arn:aws:iam::354478659547:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/6F8FBBBAS82084C6C5382099D74932645
  aws_iam_oidc_provider_arn = var.oidc_provider_arn
  // sample provider: oidc.eks.ap-northeast-1.amazonaws.com/id/6F8FBBBAS82084C6C5382099D74932645
  oidc_provider  = element(split("oidc-provider/", "${var.oidc_provider_arn}"), 1)
  namespace      = var.namespace["name"]
  serviceaccount = var.serviceaccount["name"]

}


resource "aws_iam_role" "irsa_role" {
  name = var.irsa_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${local.aws_iam_oidc_provider_arn}"
        }
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" : "sts.amazonaws.com",
            "${local.oidc_provider}:sub" : "system:serviceaccount:${local.namespace}:${local.serviceaccount}"
          }
        }

      },
    ]
  })

  tags = {
    Name = "${var.irsa_role_name}"
  }
}

# Attach IAM Policy with IAM Role
resource "aws_iam_role_policy_attachment" "irsa_iam_role_policy_attach" {
  policy_arn = var.iam_policy_arn
  role       = aws_iam_role.irsa_role.name
}

####################################################################################
# Create Namespace, ServiceAccount and Annotate the Service Account on EKS Cluster #
####################################################################################

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
  count       = (var.namespace["create_new"] && var.serviceaccount["create_new"]) ? 1 : 0
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
