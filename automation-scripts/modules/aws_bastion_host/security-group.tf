

## SEcurity Group for Bastion Host
resource "aws_security_group" "bastion_security_group" {
        name = "allow_ssh_access"
        description = "SSH from everywhere"
        vpc_id     = var.vpc_id

        ingress {
                protocol = "tcp"
                from_port = 22
                to_port = 22
                cidr_blocks = ["0.0.0.0/0"]
                description = "SSH Access"
        }

        egress {
                protocol = -1
                from_port = 0
                to_port = 0
                cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
                Name = "Bastion SG"
        }
}


