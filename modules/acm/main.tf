locals {
  tags = merge(var.tags, {"Module" = "acm"})
}

module "acm" {
  source  = "registry.terraform.io/terraform-aws-modules/acm/aws"
  version = "5.0.0"
  domain_name               = var.r53_domain_name
  subject_alternative_names = var.r53_subject_alternative_names
  zone_id                   = var.r53_zone_id
  validation_method         = "DNS"
  wait_for_validation = var.wait_for_cert_validation

  tags = local.tags
}
