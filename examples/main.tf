module "vpc" {
  source = "../modules/vpc"

  cluster_name       = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.tags
}

module "eks" {
  source = "../modules/eks"

  cluster_name               = var.cluster_name
  eks_endpoint_public_access = var.eks_endpoint_public_access
  kubernetes_version         = var.kubernetes_version
  vpc_id                     = module.vpc.vpc_id
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_subnet_ids          = module.vpc.public_subnet_ids
  kms_key_arn                = var.kms_key_arn
  node_desired_size          = var.node_desired_size
  node_max_size              = var.node_max_size
  node_min_size              = var.node_min_size
  node_instance_types        = var.node_instance_types
  node_disk_size             = var.node_disk_size
  node_capacity_type         = var.node_capacity_type
  node_labels                = var.node_labels
  tags                       = var.tags

  depends_on = [module.vpc]
}

module "k8s" {
  source          = "../modules/k8s"
  cluster_name    = var.cluster_name
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  k8s_lb_role_arn = module.eks.k8s_lb_role_arn
  app_name        = var.app_name
  namespace       = var.namespace
  replicas        = var.replicas
  # certificate_arn = module.acm.certificate_arn
  depends_on = [module.eks]
}

# deployment requires registered domain and public hosted zone in r53
# module "acm" {
#   source                        = "../../modules/acm"
#   r53_domain_name               = var.domain_name
#   r53_subject_alternative_names = var.subject_alternative_names
#   wait_for_cert_validation      = var.wait_for_cert_validation
#   r53_zone_id                   = var.zone_id
# }
