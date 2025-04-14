resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "nginx_html" {
  metadata {
    name = "${var.app_name}-html"
    namespace = var.namespace
  }

  data = {
    "index.html" = file("${path.module}/index.html")
  }
}

resource "kubernetes_service_account" "service_account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"

    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = var.k8s_lb_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service_account
  ]

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "public.ecr.aws/eks/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name = "${var.app_name}-app"
    namespace = var.namespace
    labels = {
      app = "${var.app_name}-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "${var.app_name}-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.app_name}-app"
        }
      }

      spec {
        container {
          image = "nginx:stable"
          name  = "nginx"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }

          volume_mount {
            name = "html-content"
            mount_path = "/usr/share/nginx/html/index.html"
            sub_path = "index.html"
          }
        }

        volume {
          name = "html-content"
          config_map {
            name = kubernetes_config_map.nginx_html.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "${var.app_name}-app"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx_deployment.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata {
    name = "${var.app_name}-app-alb"
    namespace = var.namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/load-balancer-name" = "${var.app_name}-app-alb"
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\":80}]"
    }
  }

  spec {
    ingress_class_name = "alb"

    default_backend {
      service {
        name = kubernetes_service.nginx_service.metadata[0].name
        port {
          number = 80
        }
      }
    }
  }
}
