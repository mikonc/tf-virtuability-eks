# Network (VPC) outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ACM Certificate outputs
# output "acm_certificate_arn" {
#   description = "The ARN of the ACM certificate"
#   value       = module.acm.certificate_arn
# }

# EKS Cluster outputs
output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "The security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}

# Kubernetes resources outputs
output "k8s_namespace" {
  description = "The name of the Kubernetes namespace"
  value       = module.k8s.namespace
}

output "k8s_deployment_name" {
  description = "The name of the Nginx deployment"
  value       = module.k8s.deployment_name
}

output "k8s_service_name" {
  description = "The name of the Kubernetes service"
  value       = module.k8s.service_name
}

output "k8s_ingress_name" {
  description = "The name of the Kubernetes ingress"
  value       = module.k8s.ingress_name
}

output "k8s_load_balancer_name" {
  description = "The name of the AWS Load Balancer"
  value       = module.k8s.load_balancer_name
}
