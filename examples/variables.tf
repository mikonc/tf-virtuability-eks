variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "region" {
  description = "AWS region where the EKS cluster will be deployed"
  type        = string
  default     = "eu-west-1"
}

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

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for encryption (optional)"
  type        = string
  default     = ""
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3

  validation {
    condition     = var.node_max_size > var.node_min_size
    error_message = "The maximum number of worker nodes must be greater than the minimum number of worker nodes."
  }
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_instance_types" {
  description = "List of instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "node_capacity_type" {
  description = "Capacity type for the worker nodes (ON_DEMAND, SPOT, or CAPACITY_BLOCK)"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT", "CAPACITY_BLOCK"], var.node_capacity_type)
    error_message = "expected capacity_type to be one of [\"ON_DEMAND\" \"SPOT\" \"CAPACITY_BLOCK\"], got ${var.node_capacity_type}"
  }
}

variable "node_labels" {
  description = "Labels to apply to the worker nodes"
  type        = map(string)
  default = {
    "role" = "web-server"
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "web-app"
}

variable "replicas" {
  description = "Number of replicas for the web server deployment"
  type        = number
  default     = 2
}

variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
  default     = "example.com"
}

variable "subject_alternative_names" {
  description = "A list of subject alternative names for the ACM certificate."
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "mikolaj-demo"
  }
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "web-app"
}

variable "nginx_image" {
  description = "Docker image for the NGINX web server"
  type        = string
  default     = "nginx:latest"
}

variable "eks_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
  default     = ""
}

variable "wait_for_cert_validation" {
  description = "Should the module wait for the certificate to be validated?"
  type        = bool
  default     = true
}
