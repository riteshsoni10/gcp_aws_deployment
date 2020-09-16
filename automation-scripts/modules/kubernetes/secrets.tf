resource "kubernetes_secret" "db_secret" {
	metadata{
		name = "mongo-db-secret"
	}

	data = {
		username      = var.db_app_username
		password      = var.db_app_password 
		database      = var.db_database_name
	}
  
}
