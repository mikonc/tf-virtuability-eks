run "cluster_name_correct" {
  command = plan

  assert {
    condition     = module.eks.cluster_name == var.cluster_name
    error_message = "EKS cluster name is different than expected!"
  }
}

run "kubernetes_version_correct" {
  command = plan

  assert {
    condition     = module.eks.kubernetes_version == var.kubernetes_version
    error_message = "Kubernetes version is different than expected!"
  }
}

run "node_desired_size_correct" {
  command = plan

  variables {
    node_desired_size = 2
  }

  assert {
    condition     = var.node_desired_size == 2
    error_message = "Node desired size is different than expected!"
  }
}

run "node_min_max_size_correct" {
  command = plan

  variables {
    node_min_size = 1
    node_max_size = 3
  }

  assert {
    condition     = var.node_min_size < var.node_max_size
    error_message = "Node min size should be less than max size!"
  }
}

run "node_instance_types_correct" {
  command = plan

  variables {
    node_instance_types = ["t3.medium"]
  }

  assert {
    condition     = contains(var.node_instance_types, "t3.medium")
    error_message = "Node instance types do not contain expected type!"
  }
}

run "public_endpoint_access_correct" {
  command = plan

  variables {
    eks_endpoint_public_access = true
  }

  assert {
    condition     = var.eks_endpoint_public_access == true
    error_message = "EKS public endpoint access is different than expected!"
  }
}

run "node_capacity_type_correct" {
  command = plan

  variables {
    node_capacity_type = "ON_DEMAND"
  }

  assert {
    condition     = var.node_capacity_type == "ON_DEMAND"
    error_message = "Node capacity type is different than expected!"
  }
}

run "node_capacity_type_invalid" {
  command = plan

  variables {
    node_capacity_type = "INVALID_TYPE"
  }

  expect_failures = [
    var.node_capacity_type,
  ]
}

run "node_labels_correct" {
  command = plan

  variables {
    node_labels = {
      "role" = "web-server"
    }
  }

  assert {
    condition     = lookup(var.node_labels, "role", "") == "web-server"
    error_message = "Node labels do not contain expected role!"
  }
}

run "cluster_tags_correct" {
  command = plan

  variables {
    tags = {
      Environment = "demo"
      Project     = "mikolaj-eks-demo"
    }
  }

  assert {
    condition     = lookup(var.tags, "Environment", "") == "demo"
    error_message = "Cluster tags do not contain expected Environment tag!"
  }
}
