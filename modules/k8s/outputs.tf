output "namespace" {
  description = "The name of the Kubernetes namespace"
  value       = kubernetes_namespace.namespace.metadata[0].name
}

output "deployment_name" {
  description = "The name of the Nginx deployment"
  value       = kubernetes_deployment.nginx_deployment.metadata[0].name
}

output "service_name" {
  description = "The name of the Kubernetes service"
  value       = kubernetes_service.nginx_service.metadata[0].name
}

output "ingress_name" {
  description = "The name of the Kubernetes ingress"
  value       = kubernetes_ingress_v1.app.metadata[0].name
}

output "load_balancer_name" {
  description = "The name of the AWS Load Balancer"
  value       = "${var.app_name}-app-alb"
}

output "service_account_name" {
  description = "The name of the service account for AWS Load Balancer Controller"
  value       = kubernetes_service_account.service_account.metadata[0].name
}
