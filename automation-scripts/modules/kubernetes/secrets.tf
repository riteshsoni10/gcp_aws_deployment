resource "kubernetes_secret" "db_secret" {
	metadata{
		name = "mongo-db-secret"
	}

	data = {
		root_username = "mongoadmin"
		root_password = "admin123"
		username = "appuser"
		password = "app1123"
		database = "nodejsdemo"
	}
  
}
