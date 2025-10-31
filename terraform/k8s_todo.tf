
resource "kubernetes_deployment" "todo" {
  metadata {
    name      = "hcp2-los2-${var.region}-deployment-todo"
    namespace = "default"
    labels = {
      app     = "todo"
      Aluno   = "hcp"
      Aluno2  = "los2"
      Periodo = "8"
    }
  }
  spec {
    replicas = var.todo_replicas
    selector {
      match_labels = { app = "todo" }
    }
    template {
      metadata { labels = { app = "todo" } }
      spec {
        container {
          name  = "todo"
          image = var.todo_image
          port { container_port = 3000 }
          resources {
            limits   = { cpu = "250m", memory = "256Mi" }
            requests = { cpu = "100m", memory = "128Mi" }
          }
        }
      }
    }
  }
  depends_on = [aws_eks_node_group.this]
}

resource "kubernetes_service" "todo" {
  metadata {
    name      = "hcp2-los2-${var.region}-service-todo"
    namespace = "default"
    labels = {
      Aluno   = "hcp"
      Aluno2  = "los2"
      Periodo = "8"
    }
  }
  spec {
    selector = { app = kubernetes_deployment.todo.metadata[0].labels.app }
    port {
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}
