resource "aws_kms_key" "eks_key" {
  count = var.kms_key_arn == "" ? 1 : 0

  description             = "KMS key for EKS cluster ${var.cluster_name} secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-kms-key"
    }
  )
}

resource "aws_kms_alias" "eks_key_alias" {
  count = var.kms_key_arn == "" ? 1 : 0

  name          = "alias/${var.cluster_name}-kms-key"
  target_key_id = aws_kms_key.eks_key[0].key_id
}
