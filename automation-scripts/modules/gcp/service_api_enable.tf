resource "google_project_service" "gke_api_enable" {
    service             = "container.googleapis.com"
    disable_on_destroy  = false
}

resource "google_project_service" "compute_engine_api_enable" {
    service             = "compute.googleapis.com"
    disable_on_destroy  = false
}