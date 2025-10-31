data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "nodegroup" {
  name               = "hcp2-los2-${var.region}-role-nodegroup"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json


  tags = {
    Name    = "hcp2-los2-${var.region}-role-nodegroup"
    Aluno   = "hcp"
    Aluno2  = "los2"
    Periodo = "8"
  }
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
