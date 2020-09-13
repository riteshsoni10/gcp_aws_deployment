## Generate TLS Key

resource "tls_private_key" "bastion_instance_key" {
	algorithm = "RSA"
}

## Creat AWS Instance Key 

resource "aws_key_pair" "bastion_instance_key" {
	key_name = var.key_name
	public_key = tls_private_key.bastion_instance_key.public_key_openssh
	depends_on = [
		tls_private_key.bastion_instance_key	
	]
}

## Save Private Key

resource "local_file" "bastion_instance_key" {
	content = tls_private_key.bastion_instance_key.private_key_pem
	filename = var.key_name
	file_permission = "0400"
	
	depends_on = [
		tls_private_key.bastion_instance_key
	]

}

