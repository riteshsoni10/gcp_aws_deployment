variable "project_id" {
    type = string
    description = "Unique Project Id for Application Deployment"
    default =  "nodejs-frontend-project"
}

variable "network_name" {
    type = string
    description = "VPC Network Name"
    default = "gcp-application"
}

variable "subnet_cidr" {
    type = string
    description = "Application Subnet CIDR/ Prefix"
}


variable "pods_network_cidr" {
    type = string
    description = "Application Pods Subnet CIDR/ Prefix"
}


variable "services_network_cidr" {
    type = string
    description = "Application Services Subnet CIDR/ Prefix"
}


variable "cluster_name"{
    type = string
    description = "Kubernetes Cluster Name"
}

variable "cluster_zone"{
    type = string
    description = "CLuster Zone name such as asiasoutheast-1"
}

variable "load_balancing_state" {
    type = bool
    description = "Boolean value to enable/disable HTTP Load Balanacing"
}

variable "pod_scaling_state" {
    type = bool
    description = "Enable/Disable Horizotal Scaling of Pods"
}

variable "node_count" {
    type = number
    description = "Number of nodes in cluster"
}

variable "node_preemptible_state" {
    type = bool
    description = "Enable/Disable Nodes Premptible state"
}

variable "node_machine_type" {
    type = string
    description = "Instance Machine Type"
}

variable "node_disk_size" {
    type = string
    description = "Node Disk Size in GB"
}

variable "node_pool_name"{
    type = string
    description = "Node Pool Cluster Name"
}
