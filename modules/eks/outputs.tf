output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "The security group ID attached to the EKS cluster"
  value       = aws_security_group.eks_cluster_sg.id
}

output "node_security_group_id" {
  description = "The security group ID attached to the EKS nodes"
  value       = aws_security_group.eks_node_sg.id
}

output "node_role_arn" {
  description = "The ARN of the IAM role for the EKS nodes"
  value       = aws_iam_role.eks_node_role.arn
}

output "node_group_id" {
  description = "The ID of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = var.kms_key_arn != "" ? var.kms_key_arn : try(aws_kms_key.eks_key[0].arn, "")
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enabled"
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "kubernetes_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.version
}

output "k8s_lb_role_arn" {
  description = "The ARN of the IAM role for the Kubernetes Load Balancer"
  value       = module.lb_role.iam_role_arn
}
