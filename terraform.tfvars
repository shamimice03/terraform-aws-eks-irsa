cluster_name      = "eks-cluster"
oidc_provider_arn = "arn:aws:iam::391178969547:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/B7AF2E49EC3DD282BAFAFD95B24CA053"
irsa_role_name    = "AWSLoadBalancerControllerRole"
iam_policy_arn    = "arn:aws:iam::391178969547:policy/AWS-LoadBalancer-Controller-Policy"

namespace = {
  create_new = false,
  name       = "kube-system"
}
serviceaccount = {
  create_new = true,
  name       = "aws-lb-controller-sa"
}

