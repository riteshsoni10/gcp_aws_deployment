output "gke_endpoint"{
    value = google_container_cluster.kubernetes_cluster.endpoint
}

output "gke_ca_certificate" {
    value = google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
}

output "gke_config" {
    value = data.google_client_config.current_config
}

output "network_id" {
    value = google_compute_network.app_network.id
}

output "worker_node_public_ips" {
	value = google_container_node_pool.kubernetes_node_pool
}
