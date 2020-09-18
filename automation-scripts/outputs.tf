
output "gcp_gke_endpoint"{
    value = module.gcp_cloud.gke_endpoint
}


output "aws_bastion_public_ip" {
	value = module.aws_bastion_host.public_ip
}

output "application_deployment" {
	value = module.application_deployment.deployment_resource
}

output "application_service" {
	value = module.application_deployment.service_resource
}

output "configmap" {
	value = module.application_deployment.configmap
}

output "demonset" {
	value = module.application_deployment.daemonset
}
