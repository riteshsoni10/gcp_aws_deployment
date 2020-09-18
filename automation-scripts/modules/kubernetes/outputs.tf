output "service_resource" {
	value = kubernetes_service.app_service
}

output "deployment_resource" {
	value = kubernetes_deployment.app_deployment
}
output "configmap" {
	value = kubernetes_config_map.iptables_nat_startup_script
}

output "daemonset" {
	value = kubernetes_daemonset.gke_vpn_nat_aws_cidr 
}
