aws_region_name  = "ap-southeast-1"
aws_user_profile ="aws_terraform_user"
gcp_region_name  = "asia-southeast1"
gcp_credentials_file_name = "gcp_creds.json"
gcp_project_id     = "nodejs-frontend-app"
gcp_subnet_cidr    = "10.10.100.0/24"
gcp_network_name   = "application"
gcp_cluster_name   = "kubernetes-cluster"
gcp_cluster_zone   = "asia-southeast1"
gcp_load_balancing_state = false
gcp_node_count                =  1
gcp_node_preemptible_state = true
gcp_node_machine_type      = "e2-medium"
gcp_node_disk_size      = 100
gcp_pod_scaling_state   = false
gcp_node_pool_name      = "cluster-node-pool"