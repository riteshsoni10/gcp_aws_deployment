resource "kubernetes_secret" "db_secret" {
	metadata{
		name = "mongo-db-secret"
	}

	data = {
		root_username = var.db_root_username
		root_password = var.db_root_password
		username      = var.db_app_username
		password      = var.db_app_password 
		database      = var.db_database_name
	}
  
}
