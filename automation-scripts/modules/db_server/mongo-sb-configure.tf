resource  "null_resource" "mongo_db_configure"{
    depends_on = [
        aws_instance.db_server,

    ]

    connection{
        type = var.connection_type
        host = aws_instance.bastion.public_ip
        user  = var.connection_user
        private_key = file(var.instance_key_name)
    }

    provisioner remote-exec {
        inline =[
            "sudo yum install python36 -y"
        ]
    }

    provisioner local-exec {
        command = "ansible-playbook -u ${var.connection_user} -i ${aws_instance.web_server.public_ip}, --private-key ${var.instance_key_name} deployment_scripts/configuration.yml -e efs_cluster_dns_name=${var.efs_cluster_dns_name} --ssh-extra-args=\"-o stricthostkeychecking=no\""
    }
}

