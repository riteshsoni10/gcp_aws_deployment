
## Google Cloud PLatform Module
output "gcp_gke_endpoint"{
    value = module.gcp_cloud.gke_endpoint
}


## AWS BAstion Module

output "aws_bastion_public_ip" {
	value = module.aws_bastion_host.public_ip
}


### AWS Module
output "aws_NAT_public_ip" {
	value = module.aws_cloud.nat_public_ip
}

output "aws_public_subnet_cidrs" {
	value = module.aws_cloud.public_subnet_cidrs
}

output "aws_private_subnet_cidrs" {
	value = module.aws_cloud.private_subnet_cidrs
}

output "aws_public_subnet_ids" {
        value = module.aws_cloud.public_subnets
}

output "aws_private_subnet_ids" {
        value = module.aws_cloud.private_subnets
}


output "database_server_private_ip" {
	value = module.database_server.db_private_ip
}

output "database_server_key_name" {
        value = module.database_server.key_name
}


## Kubernetes Module
output "application_endpoint" {
	value = module.application_deployment.service_endpoint
}
