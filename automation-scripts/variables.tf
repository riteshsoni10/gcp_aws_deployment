variable "aws_region_name" {
    type = string
    description = "AWS Region Name to launch Resources"
}

variable "aws_user_profile" {
    type = string
    description = "AWS IAM Credentials"
}

variable "aws_vpc_cidr_block" {
    type = string
    description = "AWS VPC CIDR Block"
}

variable "aws_db_ami_id" {
	type = string
	description = "Database Server AMI Id "
}

variable "aws_db_instance_type" {
	type = string
	description = "Database Server Configuration "
	default = "t2.micro"
}

variable "aws_db_key_name" {
	type = string
	description = " Database Server Instance Login Key Name"
	default = "aws_db_key"
}


variable "aws_bastion_ami_id" {
        type = string
        description = "Bastion Server AMI Id "
}

variable "aws_bastion_instance_type" {
        type = string
        description = "Database Server Configuration "
        default = "t2.micro"
}

variable "aws_bastion_key_name" {
        type = string
        description = " Database Server Instance Login Key Name"
        default = "aws_db_key"
}

variable "aws_db_server_connection_user" {
    type = string
    description = "The login user for SSH connection in DB Server"
}

variable "aws_bastion_connection_user" {
    type = string
    description = "The login user for SSH connection in Bastion Server"
}

variable "aws_connection_type" {
    type= string
    description = "Connection type for remote login"
}


## Database Server Variables

variable "aws_mongo_db_root_username" {
    type = string
    description = "Database Server Admin Username"
}

variable "aws_mongo_db_root_password" {
    type= string
    description = " Database server Admin User Password "
}

variable "aws_mongo_db_server_port" {
	type = string
	description = "Database Server Port"
}

variable "aws_mongo_db_data_path" {
	type = string
	description = "Database Server Data directory"
}

variable "aws_mongo_db_application_username" {
	type  = string
	description = "Database Application Username"
}

variable "aws_mongo_db_application_user_password" {
	type = string
	description = "Database Application User Password"

}

variable "aws_mongo_db_application_db_name" {
	type  = string
	description = "Database Name"
}


## GCP Variables

variable "gcp_credentials_file_name" {
    type = string
    description = "GCP Credentials File name"
}

variable "gcp_region_name" {
    type = string
    description = "Region Name to launch GCP Resources"

}

variable "gcp_project_id" {
    type = string
    description = "Unique Project Id for Application Deployment"
}

variable "gcp_network_name" {
    type = string
    description = "GCP VPC Network Name"
}


variable "gcp_subnet_cidr" {
    type = string
    description = "Application Subnet CIDR/ Prefix"
}



variable "gcp_pods_network_cidr" {
    type = string
    description = "Application Pods Subnet CIDR/ Prefix"
}


variable "gcp_services_network_cidr" {
    type = string
    description = "Application Pods Services Subnet CIDR/ Prefix"
}

variable "gcp_cluster_name"{
    type = string
    description = "Kubernetes Cluster Name"
}

variable "gcp_cluster_zone"{
    type = string
    description = "CLuster Zone name such as asiasoutheast-1"
}

variable "gcp_load_balancing_state" {
    type = bool
    description = "Boolean value to enable/disable HTTP Load Balanacing"
}

variable "gcp_pod_scaling_state" {
    type = bool
    description = "Enable/Disable Horizotal Scaling of Pods"
}

variable "gcp_node_count" {
    type = number
    description = "Number of nodes in cluster"
}

variable "gcp_node_preemptible_state" {
    type = bool
    description = "Enable/Disable Nodes Premptible state"
}

variable "gcp_node_machine_type" {
    type = string
    description = "Instance Machine Type"
}


variable "gcp_node_disk_size" {
    type = string
    description = "Node Disk Size in GB"
}


variable "gcp_node_pool_name"{
    type = string
    description = "Node Pool Cluster Name"
}


## Application Server Variables

variable "app_docker_image_name" {
	type = string
	description = "Docker Image for the applcation Pods"
}

variable "app_container_port" {
	type = number
	description = "Port Number on which Application is exposed in Image"
}

variable "app_expose_port" {
	type = number
	description = "Port Numer to Expose the Application in Kubernetes Service"
}
	
