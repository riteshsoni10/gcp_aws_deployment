variable "vpc_id" {
	type = string
	description = " AWS VPC Id "
}


variable "vpc_cidr_block" {
	type = string
	description = "VPC CIDR block for ssh internal access"

}

variable "db_port" {
	type = number
	description = "Database Port Number"
}

variable "gcp_network_cidrs" {
	type = list(string)
	description = "Google Cloud Network CIDR"
}

variable "key_name" {
	type = string
	description = "Instance Key Name"
}


variable "private_subnet_id" {
	type = string
	description = "Private Subnet Id"
}

variable "instance_type" {
	type = string 
	description = "Database Server Instance type"
}

variable "ami_id" {
	type = string
	description = "AMI for Database Server"
}

## CLI Command to AMI Id in region
# aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-8*" --region ap-southeast-1 --output table --profile aws_terraform_user
