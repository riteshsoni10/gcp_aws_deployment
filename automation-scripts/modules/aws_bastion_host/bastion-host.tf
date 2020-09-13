## Database Instance

resource "aws_instance" "bastion_host" {
        ami           = var.bastion_ami_id
        instance_type = var.bastion_instance_type
        subnet_id     = var.public_subnet_id
        vpc_security_group_ids = [aws_security_group.bastion_security_group.id]
        key_name               = aws_key_pair.bastion_instance_key.key_name

        tags = {
                Name = "bastion-server"
        }

        depends_on = [
                aws_security_group.bastion_security_group,
                aws_key_pair.bastion_instance_key,
        ]
}

