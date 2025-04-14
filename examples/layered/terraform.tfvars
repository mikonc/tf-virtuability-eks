## VPC vars
vpc_cidr     = "10.100.0.0/19"
availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
## EKS vars
cluster_name = "mikolaj-demo-cluster"
eks_endpoint_public_access = true
## K8s vars
namespace    = "mikolaj-demo-namespace"
app_name     = "mikolaj-demo-app"
replicas    = 2
## General vars
tags = {
  Environment = "dev"
  Project     = "mikolaj-demo"
}







