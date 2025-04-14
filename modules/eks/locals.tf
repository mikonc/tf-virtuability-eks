locals {
    tags = merge(var.tags, {"Module" = "eks"})
}
