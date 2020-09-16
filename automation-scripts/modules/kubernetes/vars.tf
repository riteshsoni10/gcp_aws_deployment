variable "mongo_db_port" {
  type = string
  description = " Database Server Port"
}

variable "app_image_name" {
  type = string
  description = "Application Docker Image Name"
}

variable "app_container_port" {
  type = string
  dscription = " Application Port"
}

variable "app_port" {
  type = string
  description = "Port for application that is exposed by Service"
}

variable "db_root_username" {
  type = string
  description = "Database Server Admin UserName"
}

variable "db_root_password" {
  type = string
  description = " Database Admin Password"
}

variable "db_app_username" {
  type = string
  description = "Database Server Application UserName"
}

variable "db_app_password" {
  type = string
  description = " Database Application User Password"
}

variable "db_database_name" {
  type = string
  description = "Application Database Name"
}
