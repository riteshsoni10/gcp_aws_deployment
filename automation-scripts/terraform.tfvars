## AWS Server Input Values
aws_region_name                         = "ap-southeast-1"
aws_user_profile                        ="aws_terraform_user"
aws_vpc_cidr_block                      = "10.100.0.0/16"
aws_db_instance_type                    = "t2.micro"
aws_db_key_name                         = "aws_db_key"
aws_db_ami_id                           = "ami-08369715d30b3f58f"
aws_bastion_instance_type               = "t2.micro"
aws_bastion_key_name                    = "aws_bastion_key"
aws_bastion_ami_id                      = "ami-08369715d30b3f58f"
aws_connection_type                     = "ssh"
aws_bastion_connection_user             = "ec2-user"
aws_db_server_connection_user           = "ec2-user"

## Application Server Input Values
app_expose_port                         = 80
app_container_port			= 3000
app_docker_image_name		        = "riteshsoni296/nodejs_app:v1"

## Database Server Input Values
aws_mongo_db_root_username              = "root"
aws_mongo_db_root_password              = "root123"
aws_mongo_db_server_port                = "27017"
aws_mongo_db_data_path                  = "/var/lib/mongo"
aws_mongo_db_application_username       = "appuser"
aws_mongo_db_application_user_password  = "appUser123"
aws_mongo_db_application_db_name        = "nodejsdemo"

## GCP Cloud Input Values
gcp_region_name                          = "asia-southeast1"
gcp_credentials_file_name                = "gcp_creds.json"
gcp_project_id                           = "nodejs-frontend-app"
gcp_subnet_cidr                          = "10.10.100.0/24"
gcp_pods_network_cidr                    = "10.172.0.0/14"
gcp_services_network_cidr                = "10.180.0.0/16"
gcp_network_name                         = "gcp-application"
gcp_cluster_name                         = "kubernetes-cluster"
gcp_cluster_zone                         = "asia-southeast1"
gcp_load_balancing_state                 = false
gcp_node_count                           =  1
gcp_node_preemptible_state               = true
gcp_node_machine_type                    = "e2-medium"
gcp_node_disk_size                       = 100
gcp_pod_scaling_state                    = false
gcp_node_pool_name                       = "cluster-node-pool"
