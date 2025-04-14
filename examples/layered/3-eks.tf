# Layer 3: EKS Cluster
# This file creates the EKS cluster and node groups

module "eks" {
  source = "../../modules/eks"

  cluster_name         = var.cluster_name
  eks_endpoint_public_access = var.eks_endpoint_public_access
  kubernetes_version   = var.kubernetes_version
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_subnet_ids    = module.vpc.public_subnet_ids
  kms_key_arn          = var.kms_key_arn
  node_desired_size    = var.node_desired_size
  node_max_size        = var.node_max_size
  node_min_size        = var.node_min_size
  node_instance_types  = var.node_instance_types
  node_disk_size       = var.node_disk_size
  node_capacity_type   = var.node_capacity_type
  node_labels          = var.node_labels
  tags                 = var.tags

  depends_on = [module.vpc]
}
