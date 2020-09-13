## Database Instance

resource "aws_instance" "db_server" {
	ami           = var.ami_id
	instance_type = var.instance_type
	subnet_id     = var.private_subnet_id
	vpc_security_group_ids = [aws_security_group.db_server_security_group.id]
	key_name               = aws_key_pair.upload_db_instance_key.key_name

	tags = {
		Name = "db-server"
	}
	
	depends_on = [
		aws_security_group.db_server_security_group,
		aws_key_pair.upload_db_instance_key,
	]
}
