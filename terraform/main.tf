data "aws_vpc" "eks" {
  id = data.aws_eks_cluster.this.vpc_config[0].vpc_id
}

data "aws_subnets" "eks" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }
}

data "aws_security_group" "eks_cluster_sg" {
  id = data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

data "aws_security_groups" "eks_vpc_sgs" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }
}

locals {
  eks_subnet_ids = data.aws_subnets.eks.ids
}
