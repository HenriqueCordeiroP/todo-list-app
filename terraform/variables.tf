variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Existing EKS cluster name"
  type        = string
  default     = "eksDeepDiveFrankfurt"
}

variable "nodegroup_name" {
  description = "Node group name (follow naming scheme)"
  type        = string
  default     = "hcp2-los2-eu-central-1-nodegroup"
}

variable "min_size" {
  type    = number
  default = 1
}
variable "desired_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 2
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "todo_image" {
  description = "Docker image for the To-do List app"
  type        = string
  default     = "325583868777.dkr.ecr.eu-central-1.amazonaws.com/hcp2-los2-eu-central-1-todo:latest"
}

variable "todo_replicas" {
  type    = number
  default = 1
}

variable "k8s_namespace" {
  type    = string
  default = "default"
}

variable "github_owner" { type = string }
variable "github_repo" { type = string }
variable "github_branch" {
  type    = string
  default = "main"
}

variable "codestar_connection_name" {
  type    = string
  default = "hcp2-los2-eu-central-1-github-connection"
}

variable "app_name" {
  type    = string
  default = "hcp2-los2-eu-central-1-todo"
}

variable "pipeline_name" {
  type    = string
  default = "hcp2-los2-eu-central-1-todo-pipeline"
}
