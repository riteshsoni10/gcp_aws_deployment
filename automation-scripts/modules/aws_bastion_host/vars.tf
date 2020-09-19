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

# CLI Command to AMI Id in region
# aws ec2 describe-images --owners 309956199498 --query 'sort_by(Images, &CreationDate)[*].[CreationDate,Name,ImageId]' --filters "Name=name,Values=RHEL-8*" --region ap-southeast-1 --output table --profile aws_terraform_user

