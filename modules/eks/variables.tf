variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
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
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
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
  description = "Capacity type for the worker nodes"
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
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "eks_endpoint_private_access" {
  description = "Whether to enable private access to the EKS cluster endpoint"
  type        = bool
  default = true
}

variable "eks_endpoint_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint"
  type        = bool
  default = false
}
