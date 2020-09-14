variable "vpc_id" {
	type = string
	description = " AWS VPC Id "
}



variable "key_name" {
	type = string
	description = "Instance Key Name"
}


variable "public_subnet_id" {
	type = string
	description = "Public Subnet Id"
}

variable "bastion_instance_type" {
	type = string 
	description = "Database Server Instance type"
}

variable "bastion_ami_id" {
	type = string
	description = "AMI for Database Server"
}


variable "connection_user" {
    type = string
    description = "The login user for SSH connection"
}

variable "connection_type" {
    type= string
    description = "Connection type for remote login"
}

variable "db_server_private_ip" {
	type = string
	description = "Database Server Private IP"
}

variable "db_connection_user" {
	type = string
	description = "Database Login User"

}

variable "db_instance_key_name" {
	type  = string
	description = "Database Server Key name"
}

# CLI Command to AMI Id in region
# aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-8*" --region ap-southeast-1 --output table --profile aws_terraform_user