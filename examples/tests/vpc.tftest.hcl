run "vpc_cidr_block_correct" {
  command = plan

  assert {
    condition     = module.vpc.vpc_cidr == var.vpc_cidr
    error_message = "VPC CIDR Block is different than expected!"
  }
}

run "vpc_cidr_block_wrong" {
  command = plan

  variables {
    vpc_cidr = "10.0.0.0/"
  }

  expect_failures = [
    var.vpc_cidr,
  ]
}

run "vpc_public_subnet_count_correct" {
  command = plan

  assert {
    condition     = length(module.vpc.public_subnets) == length(var.availability_zones)
    error_message = "VPC public subnets count is different than expected!"
  }
}
