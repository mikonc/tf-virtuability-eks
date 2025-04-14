# resource "aws_acm_certificate" "cert" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"

#   tags = merge(
#     var.tags,
#     {
#       Name = "${var.cluster_name}-cert"
#     }
#   )

#   lifecycle {
#     create_before_destroy = true
#   }
# }
