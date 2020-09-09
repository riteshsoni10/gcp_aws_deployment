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
    version = "~> 3.38"
}