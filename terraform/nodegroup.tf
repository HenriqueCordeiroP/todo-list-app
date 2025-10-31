resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = local.eks_subnet_ids



  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }


  instance_types = var.instance_types


  update_config {
    max_unavailable = 1
  }


  tags = {
    Name    = "hcp2-los2-${var.region}-nodegroup"
    Aluno   = "hcp"
    Aluno2  = "los2"
    Periodo = "8"
  }


  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}
