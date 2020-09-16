output "service_resource" {
	value = kubernetes_service.app_service
}

output "deployment_resource" {
	value = kubernetes_deployment.app_deployment
}
