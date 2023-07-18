```
cluster_name      = "eks-cluster"
oidc_provider_arn = "oidc.eks.ap-northeast-1.amazonaws.com/id/8A39B854534A32312B90A147FC317ACD"
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
```

<!--# Test Cases:-->
<!--- [ ] IAM OIDC Provider Connect-->
<!--     - New-->
<!--     - Exists (Ignore if exists)-->

<!--- [ ] IAM Policy-->
<!--     - AWS Managed Policy-->
<!--     - Custom Policy -->

<!--- [ ] Namespace and Service Account-->
<!--     - Namespace: -->
<!--       - New-->
<!--       - Exists-->
<!--     - Service Account-->
<!--       - New-->
<!--       - Exists-->