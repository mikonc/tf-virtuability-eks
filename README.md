# AWS EKS Terraform Module

This Terraform module deploys an Amazon EKS (Elastic Kubernetes Service) cluster with a simple web server that is accessible via HTTPS.

## Features

- Creates a VPC with public and private subnets across multiple availability zones
- Deploys an EKS cluster with managed node groups
- Sets up security groups and IAM roles with least privilege principles
- Deploys a simple web server with HTTPS connectivity using Helm
- Includes network policies to restrict traffic
- Provides ACM certificate for HTTPS
- Supports layered deployment for better control and management

## Usage

### Basic Usage

```hcl
module "eks_web_cluster" {
  source = "path/to/module/main"

  # Cluster configuration
  cluster_name       = "my-eks-cluster"
  region             = "eu-west-1"
  kubernetes_version = "1.28"

  # VPC configuration
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  # Node group configuration
  node_desired_size   = 2
  node_max_size       = 4
  node_min_size       = 2
  node_instance_types = ["t3.medium"]
  node_disk_size      = 20
  node_capacity_type  = "ON_DEMAND"
  node_labels = {
    "role" = "web-server"
  }

  # Web server configuration
  namespace = "web-app"
  replicas  = 2
  domain_name = "example.com"

  # Tags
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "eks-web-server"
  }
}
```

### Customizing Helm Values

You can customize the Helm chart values by providing a map of values to override:

```hcl
module "eks_web_cluster" {
  # ... other configuration ...

  # Kubernetes module configuration
  namespace = "web-app"
  replicas  = 3

  # Override Helm values
  helm_values_override = {
    # Numeric values are passed as numbers
    "replicaCount"              = 3
    "resources.limits.cpu"      = "1000m"
    "resources.limits.memory"   = "1Gi"
    "resources.requests.cpu"    = "500m"
    "resources.requests.memory" = "512Mi"

    # Boolean values are passed as booleans
    "livenessProbe.enabled"     = true

    # String values are passed as strings
    "image.tag"                 = "latest"
  }

  # Custom NGINX server block
  server_block_override = <<-EOT
    server {
      listen 0.0.0.0:8080;
      server_name example.com;

      location / {
        root /app;
        index index.html;
        try_files $uri $uri/ =404;
      }
    }
  EOT
}
```

### Layered Deployment

This module also supports a layered deployment approach, which allows you to deploy each component independently and manage them separately. See the [layered example](examples/layered/README.md) for more details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |
| kubernetes | ~> 2.23 |
| helm | ~> 2.11 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| kubernetes | ~> 2.23 |
| helm | ~> 2.11 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | `"eks-web-cluster"` | no |
| region | AWS region where the EKS cluster will be deployed | `string` | `"eu-west-1"` | no |
| vpc_cidr | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| availability_zones | List of availability zones to use for the subnets | `list(string)` | `["eu-west-1a", "eu-west-1b", "eu-west-1c"]` | no |
| kubernetes_version | Kubernetes version to use for the EKS cluster | `string` | `"1.28"` | no |
| kms_key_arn | ARN of the KMS key used for encryption (optional) | `string` | `""` | no |
| node_desired_size | Desired number of worker nodes | `number` | `2` | no |
| node_max_size | Maximum number of worker nodes | `number` | `4` | no |
| node_min_size | Minimum number of worker nodes | `number` | `2` | no |
| node_instance_types | List of instance types for the worker nodes | `list(string)` | `["t3.medium"]` | no |
| node_disk_size | Disk size in GiB for worker nodes | `number` | `20` | no |
| node_capacity_type | Capacity type for the worker nodes (ON_DEMAND or SPOT) | `string` | `"ON_DEMAND"` | no |
| node_labels | Labels to apply to the worker nodes | `map(string)` | `{}` | no |
| namespace | Kubernetes namespace for the application | `string` | `"web-app"` | no |
| replicas | Number of replicas for the web server deployment | `number` | `2` | no |
| domain_name | Domain name for the ACM certificate | `string` | `"example.com"` | no |
| helm_values_override | Map of Helm values to override the defaults | `map(any)` | `{}` | no |
| server_block_override | Custom NGINX server block configuration | `string` | `""` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{ Environment = "dev", Terraform = "true", Project = "eks-web-server" }` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr | The CIDR block of the VPC |
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| cluster_id | The ID of the EKS cluster |
| cluster_arn | The ARN of the EKS cluster |
| cluster_endpoint | The endpoint for the EKS cluster API server |
| cluster_security_group_id | The security group ID attached to the EKS cluster |
| node_security_group_id | The security group ID attached to the EKS nodes |
| node_role_arn | The ARN of the IAM role for the EKS nodes |
| node_group_id | The ID of the EKS node group |
| kms_key_arn | The ARN of the KMS key used for encryption |
| web_service_name | Name of the web server service |
| web_service_namespace | Namespace of the web server service |
| web_service_load_balancer_hostname | Hostname of the load balancer for the web server service |
| acm_certificate_arn | The ARN of the ACM certificate |
| helm_release_name | Name of the Helm release |
| helm_release_version | Version of the Helm release |
| helm_release_status | Status of the Helm release |

## Security Considerations

This module implements several security best practices:

1. **Network Isolation**: The EKS nodes are placed in private subnets, with only the load balancer in public subnets.
2. **Least Privilege IAM Roles**: IAM roles follow the principle of least privilege.
3. **Secrets Encryption**: EKS secrets are encrypted using KMS.
4. **Network Policies**: Kubernetes network policies restrict pod-to-pod communication.
5. **HTTPS**: The web server is accessible via HTTPS using an ACM certificate.
6. **Security Groups**: Security groups restrict traffic to only what is necessary.

## Testing

To run the tests for this module:

```bash
cd tests
terraform init
terraform validate
terraform plan
```

## License

This module is licensed under the MIT License - see the LICENSE file for details.
