output "service_endpoint" {
	value = kubernetes_service.app_service.load_balancer_ingress.0.ip
}

