resource "google_container_cluster" "kubernetes_cluster" {
    name = var.cluster_name
    location = var.cluster_zone

    master_auth {
        username  = ""
        password  = ""

        client_certificate_config {
            issue_client_certificate = false
        }
    }

    ip_allocation_policy {
	cluster_ipv4_cidr_block = var.pods_network_cidr
	services_ipv4_cidr_block = var.services_network_cidr
    }
    remove_default_node_pool = true
    initial_node_count = var.node_count
    network = google_compute_network.app_network.name
    subnetwork = google_compute_subnetwork.app_subnet.name
    
    addons_config {
        http_load_balancing {
            disabled = var.load_balancing_state
        }

        horizontal_pod_autoscaling {
            disabled = var.pod_scaling_state
        }
    }

}


resource "google_container_node_pool" "kubernetes_node_pool"{
    name = var.node_pool_name
    location = var.cluster_zone
    cluster = google_container_cluster.kubernetes_cluster.name
    node_count = var.node_count

    node_config {
        preemptible = var.node_preemptible_state
        metadata = {
            disable-legacy-endpoints = "true"
        }
        disk_size_gb = var.node_disk_size
        machine_type = var.node_machine_type
        oauth_scopes = [
           "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
        ]
    }
}
