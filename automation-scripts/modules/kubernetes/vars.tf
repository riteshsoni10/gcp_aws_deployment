variable "mongo_db_port" {
  type = string
  description = " Database Server Port"
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
