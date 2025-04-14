# OUTPUTS

output "certificate_arn" {
  description = "ARN of the certificate."
  value       = try(module.acm.acm_certificate_arn, "")
}

output "domain_name" {
  description = "Domain name for which the certificate should be issued."
  value       = try(var.r53_domain_name, "")
}
