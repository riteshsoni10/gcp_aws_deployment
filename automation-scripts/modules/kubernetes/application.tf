
resource "kubernetes_deployment" "app_deployment" {
    depends_on = [
        kubernetes_secret.db_secret,
	#kubernetes_daemonset.gke_vpn_nat_aws_cidr,
    ]
    metadata {
        name = "app-deploy"
        labels = {
            app = "nodejs"
        }
    }
    spec{
        selector {
            match_labels = {
                app = "nodejs"
                tier = "frontend"
            }
        }
        strategy {
            type = "Recreate"
        }
        template {
            metadata {
                name = "app-pod"
                labels = {
                    app = "nodejs"
                    tier = "frontend"
                }
            }
            spec {
                container {
                    name = "app-container"
                    image = var.app_image_name
                    port {
                        name= "app-port"
                        container_port = var.app_container_port
                    }
                    env {
                        name  = "DATABASE_USER"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.db_secret.metadata[0].name
                                key = "username"
                            }
                        }
                    }
                    env {
                        name  = "DATABASE_PASSWORD"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.db_secret.metadata[0].name
                                key = "password"
                            }
                        }
                    }
                    env {
                        name  = "DATABASE"
                        value_from {
                            secret_key_ref {
                                name = kubernetes_secret.db_secret.metadata[0].name
                                key  = "database"
                            }
                        }
                    }
                    env {
                        name  = "DATABASE_SERVER"
                        value =  var.mongo_db_host
                    }
                    env {
                        name  = "DATABASE_PORT"
                        value = var.mongo_db_port
                    }
                }
            }
        }
    }
}

## Kubernetes Service resource for Application server

resource "kubernetes_service" "app_service" {
    metadata {
        name = "app-svc"
    }
    spec{
        selector = {
            app = kubernetes_deployment.app_deployment.spec[0].template[0].metadata[0].labels.app
            tier = kubernetes_deployment.app_deployment.spec[0].template[0].metadata[0].labels.tier
        }
        port {
            port        = var.app_port
            target_port = var.app_container_port
        }
        type = "LoadBalancer"
    }

    depends_on = [
        kubernetes_deployment.app_deployment
    ]
}
