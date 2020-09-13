terraform {
    required_version = ">= 0.12"
}


provider "aws" {
    region = var.aws_region_name
    profile = var.aws_user_profile
    version = "~> 3.5"
}

provider "google" {
    region      = var.gcp_region_name
    credentials = file(var.gcp_credentials_file_name)
    project     = var.gcp_project_id
    version = "~> 3.38"
}

provider "kubernetes" {
    version = "~> 1.13"
    load_config_file = false
    host = "https://${module.gcp_cloud.gke_endpoint}"
    cluster_ca_certificate = base64decode(module.gcp_cloud.gke_ca_certificate)
    token = module.gcp_cloud.gke_config.access_token
}

module "gcp_cloud" {
    source = "./modules/gcp"
    subnet_cidr = var.gcp_subnet_cidr
    network_name = var.gcp_network_name
    cluster_name = var.gcp_cluster_name
    cluster_zone = var.gcp_cluster_zone
    load_balancing_state = var.gcp_load_balancing_state
    node_count = var.gcp_node_count
    node_disk_size  = var.gcp_node_disk_size
    node_preemptible_state = var.gcp_node_preemptible_state
    node_machine_type = var.gcp_node_machine_type
    pod_scaling_state = var.gcp_pod_scaling_state
    node_pool_name = var.gcp_node_pool_name
}

module "aws_cloud" {
    source = "./modules/aws"
    vpc_cidr_block = var.aws_vpc_cidr_block
}

module "gcp_aws_vpn" {
    source = "./modules/vpn"
    aws_vpc_id = module.aws_cloud.vpc_id
    aws_route_table_ids = [module.aws_cloud.public_route_table_id, module.aws_cloud.private_route_table_id]
    gcp_network_id = module.gcp_cloud.network_id
}

module "database_server" {
   source = "./modules/db_server"
   vpc_id             = module.aws_cloud.vpc_id
   gcp_network_cidr   = var.gcp_subnet_cidr
   ami_id             = var.aws_db_ami_id
   instance_type      = var.aws_db_instance_type
   private_subnet_id  = module.aws_cloud.private_subnet_id
   key_name           = var.aws_db_key_name
}
