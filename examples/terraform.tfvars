## VPC vars
vpc_cidr           = "10.100.0.0/19"
availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

## EKS vars
cluster_name               = "mikolaj-demo-cluster"
eks_endpoint_public_access = true
node_max_size              = 3
node_min_size              = 1
node_desired_size          = 2

## K8s vars
namespace = "mikolaj-demo-namespace"
app_name  = "mikolaj-demo"
replicas  = 2

## ACM vars
# domain_name               = "matuszny.poc.com"
# subject_alternative_names = ["*.poc.com"]
# wait_for_cert_validation  = true
# zone_id                   = ""

## General vars
tags = {
  Environment = "demo"
  Project     = "mikolaj-eks-demo"
}

region = "eu-west-1"
