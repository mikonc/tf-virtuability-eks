variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = var.vpc_cidr == null ? true : can(cidrsubnet(var.vpc_cidr, 0, 0))
    error_message = "Must be a valid CIDR notation, e.g. 10.0.0.0/24."
  }
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}
