variable "aws_region_name" {
    type = string
    description = "AWS Region Name to launch Resources"
}

variable "aws_user_profile" {
    type = string
    description = "AWS IAM Credentials"
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