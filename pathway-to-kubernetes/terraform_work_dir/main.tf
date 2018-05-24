provider "kubernetes" {}

/*
Deploy Replication controller
*/

resource "kubernetes_replication_controller" "nginx" {
  metadata {
    name = "scalable-nginx-sample-app"
    labels {
      App = "ScalableNginxSampleApp"
    }
  }

  spec {
    replicas = 2
    selector {
      App = "ScalableNginxSampleApp"
    }
    template {
      container {
        image = "nginx:1.7.8"
        name  = "example"

        port {
          container_port = 80
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-sample-app"
  }
  spec {
    selector {
      App = "${kubernetes_replication_controller.nginx.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "loadbalancer_ip" {
  value = "${kubernetes_service.nginx.load_balancer_ingress.0.hostname}"
}



