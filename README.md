# AWS EKS Terraform Module
This Terraform module deploys a VPC, Amazon EKS cluster with a simple web server that is accessible via HTTP.

## Features
- Creates a VPC with public and private subnets across multiple availability zones
- Deploys an EKS cluster with managed node groups
- Sets up security groups and IAM roles with least privilege principles
- Deploys a simple web server with HTTP connectivity
- Provides ACM certificate for HTTPS (optionally)

## Example usage
See the [example](examples/layered/README.md) for a complete example of how to use this module.

To deploy the infrastructure make sure you have AWS credentials configured and follow these steps:
1. Navigate to `examples` directory
2. Run `terraform init`
3. Run `terraform apply -var-file=terraform.tfvars`
4. Wait for the deployment to complete. This may take up to 30 minutes. In case of apply error, re-run the apply command.
5. Access the web server by using Application Load Balancer DNS name.

## Terraform tests
To run the tests, navigate to the `examples` directory and run `terraform test` command.

## Security Considerations
This module implements several security best practices:

1. **Network Isolation**: The EKS nodes are placed in private subnets, with only the load balancer in public subnets.
2. **Least Privilege IAM Roles**: IAM roles follow the principle of least privilege.
3. **Secrets Encryption**: EKS secrets are encrypted using KMS.
4. **Security Groups**: Security groups restrict traffic to only what is necessary.
