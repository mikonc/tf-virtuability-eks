variable "k8s_lb_role_arn" {
  description = "The ARN of the IAM role for the Kubernetes Load Balancer"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::\\d{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.k8s_lb_role_arn))
    error_message = "The k8s_lb_role_arn must be a valid ARN."
  }
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.cluster_name))
    error_message = "The cluster_name must be alphanumeric and can include hyphens."
  }
}

variable "region" {
  description = "The AWS region where the cluster is deployed"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster is deployed"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace where resources will be deployed"
  type        = string
  default     = "default"
}

variable "app_name" {
  description = "The name of the application to be deployed"
  type        = string
  default     = "nginx"
}

variable "replicas" {
  description = "The number of replicas for the application"
  type        = number
  default     = 2
}
