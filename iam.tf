resource "aws_iam_policy" "eks_access_policy" {
  name        = "EKSAccessPolicy"
  description = "IAM policy for EKS access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:AccessKubernetesApi"
        "eks:ListFargateProfiles",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:ListUpdates",
        "eks:ListAddons",
        "eks:DescribeAddonVersions",
        "eks:ListIdentityProviderConfigs",
        "iam:ListRoles"
        // Add other EKS-related permissions as needed
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attach_eks_access_policy" {
  user       = "your_iam_user_name"
  policy_arn = aws_iam_policy.eks_access_policy.arn
}
resource "kubernetes_cluster_role" "eks_access_role" {
  metadata {
    name = "eks-access-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps"] // Add more resources as needed
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "eks_access_binding" {
  metadata {
    name = "eks-access-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.eks_access_role.metadata[0].name
  }

  subject {
    kind      = "User"
    name      = "your_iam_user_name"
    api_group = null
  }
}
