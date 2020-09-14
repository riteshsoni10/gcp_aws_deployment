output "db_private_ip" {
	value = aws_instance.db_server.private_ip
}

output "key_name" {
	value = aws_key_pair.upload_db_instance_key.key_name
}
