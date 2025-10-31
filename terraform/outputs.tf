output "eks_cluster_name" {
  value = var.cluster_name
}

output "eks_cluster_endpoint" {
  value = data.aws_eks_cluster.this.endpoint
}

output "vpc_id" {
  value = data.aws_vpc.eks.id
}

output "subnet_ids" {
  value = local.eks_subnet_ids
}

output "cluster_security_group_id" {
  value = data.aws_security_group.eks_cluster_sg.id
}

# Recursos criados
output "node_group_name" {
  value = aws_eks_node_group.this.node_group_name
}

output "service_hostname_or_ip" {
  description = "Quando type=LoadBalancer, vira o hostname/IP externo"
  value       = try(kubernetes_service.todo.status[0].load_balancer[0].ingress[0].hostname, null)
}

output "kubeconfig_hint" {
  value = <<EOT
aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}
# kubectl get node -o wide
# kubectl get svc -n ${var.k8s_namespace}
EOT
}
