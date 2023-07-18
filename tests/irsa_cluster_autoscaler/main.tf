locals {
  cluster_name = "eks-cluster"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth
data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "irsa" {
  source = "github.com/shamimice03/terraform-aws-eks-irsa"
  
  create            = false
  cluster_name      = local.cluster_name
  oidc_provider_arn = "arn:aws:iam::391178969547:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/B7AF2E49EC3DD282BAFAFD95B24CA053"
  irsa_role_name    = "ClusterAutoscalerIRSA"
  iam_policy_arn    = aws_iam_policy.this.arn

  namespace = {
    create_new = true,
    name       = "cluster-autoscaler"
  }
  serviceaccount = {
    create_new = true,
    name       = "cluster-autoscaler-sa"
  }

}


