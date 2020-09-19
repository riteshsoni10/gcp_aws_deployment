
variable "connection_user" {
    type = string
    description = "The login user for SSH connection"
}

variable "connection_type" {
    type= string
    description = "Connection type for remote login"
}

variable "db_server_private_ip" {
        type = string
        description = "Database Server Private IP"
}

variable "db_connection_user" {
        type = string
        description = "Database Login User"

}

variable "db_instance_key_name" {
        type  = string
        description = "Database Server Key name"
}


variable "bastion_host_key_name" {
        type  = string
        description = "Bastion Server Key name"
}


variable "bastion_host_public_ip" {
        type  = string
        description = "Bastion Server Public IP"
}


## Mongo Database Server Configuration variables

variable "mongo_db_root_username" {
    type = string
    description = "The login user for SSH connection"
}

variable "mongo_db_root_password" {
    type= string
    description = "Connection type for remote login"
}

variable "mongo_db_server_port" {
        type = string
        description = "Database Server Private IP"
}

variable "mongo_db_data_path" {
        type = string
        description = "Database Login User"

}

variable "mongo_db_application_username" {
        type  = string
        description = "Database Server Key name"
}

variable "mongo_db_application_user_password" {
        type = string
        description = "Database Login User"

}

variable "mongo_db_application_db_name" {
        type  = string
        description = "Database Server Key name"
}

