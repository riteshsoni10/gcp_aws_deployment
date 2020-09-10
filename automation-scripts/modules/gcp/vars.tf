variable "project_id" {
    type = string
    description = "Unique Project Id for Application Deployment"
    default =  "nodejs-frontend-project"
}

variable "network_name" {
    type = string
    description = "VPC Network Name"
    default = "application"
}

variable "subnet_cidr" {
    type = string
    description = "Application Subnet CIDR/ Prefix"
}
