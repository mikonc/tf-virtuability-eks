# Layered EKS Deployment Example

This example demonstrates how to deploy the EKS cluster and web server in separate layers. This approach allows you to deploy each component independently and manage them separately.

## Layers

The deployment is divided into the following layers:

1. **Network (VPC)** - Creates the VPC, subnets, and other networking resources
2. **ACM Certificate** - Creates the ACM certificate for HTTPS
3. **EKS Cluster** - Creates the EKS cluster and node groups
4. **Kubernetes Resources** - Deploys the web server to the EKS cluster using Helm

## Usage

### Initialize Terraform

```bash
terraform init
```

### Deploy Layer 1: Network (VPC)

```bash
terraform apply -target=module.vpc
```

### Deploy Layer 2: ACM Certificate

```bash
terraform apply -target=module.acm
```

### Deploy Layer 3: EKS Cluster

```bash
terraform apply -target=module.eks
```

### Deploy Layer 4: Kubernetes Resources

```bash
terraform apply -target=module.k8s
```

### Deploy All Layers

If you want to deploy all layers at once:

```bash
terraform apply
```

## Viewing Outputs

You can view the outputs of each layer using the following commands:

### Network (VPC) Outputs

```bash
terraform output -json | jq '.vpc_id.value'
terraform output -json | jq '.vpc_cidr.value'
terraform output -json | jq '.public_subnet_ids.value'
terraform output -json | jq '.private_subnet_ids.value'
```

### ACM Certificate Outputs

```bash
terraform output -json | jq '.acm_certificate_arn.value'
terraform output -json | jq '.acm_certificate_domain_name.value'
```

### EKS Cluster Outputs

```bash
terraform output -json | jq '.cluster_id.value'
terraform output -json | jq '.cluster_endpoint.value'
terraform output -json | jq '.cluster_security_group_id.value'
```

### Kubernetes Resources Outputs

```bash
terraform output -json | jq '.web_service_name.value'
terraform output -json | jq '.web_service_namespace.value'
terraform output -json | jq '.web_service_load_balancer_hostname.value'
terraform output -json | jq '.helm_release_name.value'
terraform output -json | jq '.helm_release_status.value'
```

## Accessing the Web Server

After all layers are deployed, you can access the web server using the load balancer hostname:

```bash
echo "Web server URL: https://$(terraform output -raw web_service_load_balancer_hostname)"
```

## Cleaning Up

To destroy the resources in reverse order:

```bash
terraform destroy -target=module.k8s
terraform destroy -target=module.eks
terraform destroy -target=module.acm
terraform destroy -target=module.vpc
```

Or to destroy all resources at once:

```bash
terraform destroy
```bash
terraform destroy
```
