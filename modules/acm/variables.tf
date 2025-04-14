variable "r53_domain_name" {
  description = "The domain name for the Route 53 zone."
  type        = string
}

variable "r53_subject_alternative_names" {
  description = "A list of subject alternative names for the ACM certificate."
  type        = list(string)
  default     = []
}

variable "wait_for_cert_validation" {
  description = "Should the module wait for the certificate to be validated before returning."
  type        = bool
  default     = true
}

variable "r53_zone_id" {
  description = "The ID of the Route 53 zone."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
