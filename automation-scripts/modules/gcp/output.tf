output "gke_endpoint"{
    value = google_container_cluster.kubernetes_cluster.endpoint
}

output "gke_ca_certificate" {
    value = google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
}

output "gke_config" {
    value = data.google_client_config.current_config
}