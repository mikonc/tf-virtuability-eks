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
#   value       = aws_acm_certificate.cert.arn
# }

# output "acm_certificate_domain_name" {
#   description = "The domain name of the ACM certificate"
#   value       = aws_acm_certificate.cert.domain_name
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

# # Kubernetes resources outputs
# output "web_service_name" {
#   description = "Name of the web server service"
#   value       = module.k8s.web_service_name
# }

# output "web_service_namespace" {
#   description = "Namespace of the web server service"
#   value       = module.k8s.web_service_namespace
# }

# output "web_service_load_balancer_hostname" {
#   description = "Hostname of the load balancer for the web server service"
#   value       = module.k8s.web_service_load_balancer_hostname
# }

# output "helm_release_name" {
#   description = "Name of the Helm release"
#   value       = module.k8s.helm_release_name
# }

# output "helm_release_status" {
#   description = "Status of the Helm release"
#   value       = module.k8s.helm_release_status
# }
