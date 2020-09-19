## Security Group

resource "aws_security_group" "db_server_security_group" {
	name = "allow_ssh_mysql_access"
	description = "Mysql Server Access from GCP and SSH from VPC Network"
	vpc_id     = var.vpc_id
	
	ingress {
		protocol = "tcp"
		from_port = 22
		to_port = 22
		cidr_blocks = [var.vpc_cidr_block]
		description = "SSH Access"
	}
	
	ingress {
		protocol = "tcp"
		from_port = var.db_port
		to_port =   var.db_port
		cidr_blocks = var.gcp_network_cidrs
		description = "Mysql Server Access from GCP Cloud "
	}

	egress {
		protocol = -1
		from_port = 0
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "Database SG"
	}
}


