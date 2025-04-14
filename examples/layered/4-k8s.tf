module "k8s" {
  source = "../../modules/k8s"
  cluster_name = var.cluster_name
  region = var.region
  vpc_id = module.vpc.vpc_id
  k8s_lb_role_arn = module.eks.k8s_lb_role_arn
  app_name = var.app_name
  namespace                        = var.namespace
  replicas                         = var.replicas
  depends_on = [module.eks]
}
