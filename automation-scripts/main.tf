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


module "gcp_cloud" {
    source = "./modules/gcp"
    subnet_cidr = var.gcp_subnet_cidr
    network_name = var.gcp_network_name

}