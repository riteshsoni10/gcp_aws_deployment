resource "null_resource" "upload_db_playbook"{
	provisioner "file" {
		source = "db_configuration_scripts"
		destination = "/opt"
	
		connection {
      			type     = var.connection_type
      			user     = var.connecion_user
      			private_key = file(aws_key_pair.bastion_instance_key.key_name)
			host     = aws_instance.bastion_host.public_ip
    		}
	}

	depends_on = [
		aws_instance.bastion_host,
	]


}

resource "null_resource" "upload_db_server_key" {
	provisioner "file" {
                source = var.db_instance_key_name
                destination = "/opt"

                connection {
                        type     = var.connection_type
                        user     = var.connecion_user
                        private_key = file(aws_key_pair.bastion_instance_key.key_name)
                        host     = aws_instance.bastion_host.public_ip
                }
        }


	depends_on = [
		null_resource.upload_db_playbook
	]
}


resource  "null_resource" "mongo_db_configure"{
    depends_on = [
	null_resource.upload_db_server_key
    ]

    connection{
        type = var.connection_type
        host = aws_instance.bastion_host.public_ip
        user  = var.connection_user
        private_key = file(aws_key_pair.bastion_instance_key.key_name)
    }

    provisioner remote-exec {
        inline =[
            "sudo yum install python36 -y",
	    "ansible-playbook -u ${var.db_connection_user} -i ${var.db_server_private_ip}, --private-key ${var.db_instance_key_name} /opt/deployment_scripts/configuration.yml --ssh-extra-args=\"-o stricthostkeychecking=no\""
        ]
    }

}

