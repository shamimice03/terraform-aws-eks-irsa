cluster_name      = "eks-cluster"
oidc_provider_arn = "arn:aws:iam::391178969547:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/6F8F05C582084C6C5382099D74932645"
irsa_role_name    = "AWSLoadBalancerControllerRole"
iam_policy_arn    = "arn:aws:iam::391167669547:policy/AWS-LoadBalancer-Controller-Policy"
namespace = {
  create_new = false,
  name       = "kube-system"
}
serviceaccount = {
  create_new = true,
  name       = "aws-lb-controller-sa"
}

