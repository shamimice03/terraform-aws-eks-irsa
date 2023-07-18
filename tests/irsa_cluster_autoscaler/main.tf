locals {
  cluser_name = "eks-cluster"
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
  
  source            = "github.com/shamimice03/terraform-aws-eks-irsa"
  cluster_name      = local.cluser_name
  oidc_provider_arn = "oidc.eks.ap-northeast-1.amazonaws.com/id/8A39B854534A32312B90A147FC317ACD"
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
