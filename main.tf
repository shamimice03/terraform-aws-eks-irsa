data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "tls_certificate" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

### Check the exists using data block - https://jhooq.com/terraform-check-if-resource-exist/
### Existing IAM oidc provider
### get url of provider endpoint (from eks details)
### retrieve arn


resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

locals {
  # change for existing provider
  aws_iam_oidc_provider_arn = aws_iam_openid_connect_provider.this.arn
}



# Resource: Create IAM Role and associate the IAM Policy to it

resource "aws_iam_role" "irsa_role" {
  name = var.irsa_role_name

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
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
            "${local.oidc_provider}:sub" : "system:serviceaccount:${var.namespace}:${var.serviceaccount}"
          }
        }

      },
    ]
  })

  tags = {
    Name = "${var.irsa_role_name}"
  }
}

# Associate IAM Role and Policy
resource "aws_iam_role_policy_attachment" "irsa_iam_role_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.irsa_role.name
}

output "irsa_iam_role_arn" {
  description = "IRSA Demo IAM Role ARN"
  value       = aws_iam_role.irsa_role.arn
}