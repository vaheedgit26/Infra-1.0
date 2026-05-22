locals {
  resource_name = "${var.project}-${var.env}"

  # Full EKS cluster name used for resource naming and tagging
  # eks_cluster_name = "${local.resource_name}-eks-cluster"         # Example: "retail-dev-eks-cluster"
}
