resource "digitalocean_kubernetes_cluster" "homero" {
  name    = "${var.do_name}"
  region  = "${var.do_region}"
  version = "${var.do_kubernetes_version}"
  tags    = "${var.do_tags}"

  node_pool {
    name       = "${var.do_name}"
    size       = "${var.do_size}"
    node_count = "${var.do_kubernetes_nodes}" 
  }

}
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
resource "kubernetes_deployment" "homero" {
  metadata {
    name = "homero-deploy"
    namespace = "dev"
    labels {
      app = "homero"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels {
        app = "homero"
      }
    }

    template {
      metadata {
        labels {
          app = "homero"
        }
      }

      spec {
        container {
          image = "${var.container_image}"
          name  = "homero-app"

          resources{
            limits{
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests{
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
// Ingress not yet implemented in k8s provider https://github.com/terraform-providers/terraform-provider-kubernetes/issues/14

resource "kubernetes_service" "homero" {
  metadata {
    name = "homero-svc"
    namespace = "dev"
  }
  spec {
    selector {
      app = "${kubernetes_deployment.homero.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = 80
      target_port = "${var.container_port}"
    }
    type = "LoadBalancer"
  }
}

resource "digitalocean_record" "homero" {
  domain     = "${var.dns_domain}"
  name       = "${var.dns_record}"
  value      = "${kubernetes_service.homero.load_balancer_ingress.0.ip}"
  type       = "A"
  ttl        = "300"
}