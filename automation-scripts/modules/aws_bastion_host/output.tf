
output "public_ip"{
        value = aws_instance.bastion_host.public_ip
}

output "key_name" {
	value = aws_key_pair.bastion_instance_key.key_name
}
