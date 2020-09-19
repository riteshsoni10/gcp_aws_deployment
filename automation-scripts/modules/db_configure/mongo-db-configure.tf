resource "null_resource" "upload_db_playbook"{
	provisioner "file" {
		source = "db_configuration_scripts"
		destination = "/tmp/"
	
		connection {
      			type        = var.connection_type
      			user        = var.connection_user
      			private_key = file(var.bastion_host_key_name)
			host        = var.bastion_host_public_ip
    		}
	}

}

resource "null_resource" "upload_db_server_key" {
	provisioner "file" {
                source = var.db_instance_key_name
                destination = "/tmp/${var.db_instance_key_name}"

                connection {
                        type     = var.connection_type
                        user     = var.connection_user
                        private_key = file(var.bastion_host_key_name)
                        host     = var.bastion_host_public_ip
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
        host = var.bastion_host_public_ip
        user  = var.connection_user
        private_key = file(var.bastion_host_key_name)
    }

    provisioner remote-exec {
        inline =[
            "sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
	    "sudo dnf install ansible -y",
	    "sudo ansible-playbook -u ${var.db_connection_user} -i ${var.db_server_private_ip}, --private-key /tmp/${var.db_instance_key_name} /tmp/db_configuration_scripts/db_server.yml  -e mongo_db_root_username=${var.mongo_db_root_username} -e mongo_db_root_password=${var.mongo_db_root_password} -e mongo_db_server_port=${var.mongo_db_server_port} -e mongo_db_data_path=${var.mongo_db_data_path} -e application_username=${var.mongo_db_application_username} -e application_user_password=${var.mongo_db_application_user_password} -e application_db_name=${var.mongo_db_application_db_name}  --ssh-extra-args=\"-o stricthostkeychecking=no\""
        ]
    }

}

