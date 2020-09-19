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
    source                 = "./modules/gcp"
    subnet_cidr            = var.gcp_subnet_cidr
    pods_network_cidr      = var.gcp_pods_network_cidr
    services_network_cidr  = var.gcp_services_network_cidr
    network_name           = var.gcp_network_name
    cluster_name           = var.gcp_cluster_name
    cluster_zone           = var.gcp_cluster_zone
    load_balancing_state   = var.gcp_load_balancing_state
    node_count             = var.gcp_node_count
    node_disk_size         = var.gcp_node_disk_size
    node_preemptible_state = var.gcp_node_preemptible_state
    node_machine_type      = var.gcp_node_machine_type
    pod_scaling_state      = var.gcp_pod_scaling_state
    node_pool_name         = var.gcp_node_pool_name
}


module "aws_cloud" {
    source = "./modules/aws_network"
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
   vpc_cidr_block        = var.aws_vpc_cidr_block
   gcp_network_cidrs   = [var.gcp_subnet_cidr,var.gcp_pods_network_cidr,var.gcp_services_network_cidr]
   ami_id             = var.aws_db_ami_id
   instance_type      = var.aws_db_instance_type
   db_port            = var.aws_mongo_db_server_port
   private_subnet_id  = module.aws_cloud.private_subnets[0]
   key_name           = var.aws_db_key_name
}


module "aws_bastion_host" {
  source                             = "./modules/aws_bastion_host"
  vpc_id                             = module.aws_cloud.vpc_id
  bastion_ami_id                     = var.aws_bastion_ami_id
  bastion_instance_type              = var.aws_bastion_instance_type
  public_subnet_id                   = module.aws_cloud.public_subnets[0]
  key_name                           = var.aws_bastion_key_name
}

module "db_server_configure" {
  source = "./modules/db_configure"
  connection_user                    = var.aws_bastion_connection_user
  db_connection_user                 = var.aws_db_server_connection_user
  connection_type                    = var.aws_connection_type
  bastion_host_public_ip             = module.aws_bastion_host.public_ip
  bastion_host_key_name              = module.aws_bastion_host.key_name 
  db_server_private_ip               = module.database_server.db_private_ip
  db_instance_key_name               = module.database_server.key_name
  mongo_db_root_username             = var.aws_mongo_db_root_username
  mongo_db_root_password             = var.aws_mongo_db_root_password
  mongo_db_server_port               = var.aws_mongo_db_server_port
  mongo_db_data_path                 = var.aws_mongo_db_data_path
  mongo_db_application_username      = var.aws_mongo_db_application_username
  mongo_db_application_user_password = var.aws_mongo_db_application_user_password
  mongo_db_application_db_name       = var.aws_mongo_db_application_db_name

}

module "application_deployment" {
    source              = "./modules/kubernetes"
    aws_vpc_cidr        = var.aws_vpc_cidr_block
    mongo_db_host       = module.database_server.db_private_ip
    mongo_db_port       = var.aws_mongo_db_server_port
    app_image_name      = var.app_docker_image_name
    app_container_port  = var.app_container_port
    app_port            = var.app_expose_port
    db_app_username     = var.aws_mongo_db_application_username
    db_app_password     = var.aws_mongo_db_application_user_password
    db_database_name    = var.aws_mongo_db_application_db_name 
}
      
