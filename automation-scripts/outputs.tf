
output "gcp_gke_endpoint"{
    value = module.gcp_cloud.gke_endpoint
}


output "aws_bastion_public_ip" {
	value = module.aws_bastion_host.public_ip
}
