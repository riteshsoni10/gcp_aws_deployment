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