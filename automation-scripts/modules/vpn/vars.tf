variable "aws_vpc_id" {
    type = string
    description = " AWS VPC Id"
}

variable "aws_route_table_ids" {
    type = list(string)
    description = "AWS Public and Private Route Table Ids"
}


variable "gcp_network_id" {
    type = string
    description = "GCP Network Id"
}
