## VPC Network
resource "google_compute_network" "app_network" {
    name                    = "${var.network_name}-vpc"
    auto_create_subnetworks = false
}

## Create Subnets
resource "google_compute_subnetwork" "app_subnet" {
    name          = "${var.network_name}-subnet"
    ip_cidr_range = var.subnet_cidr
    network       = "${var.network_name}-vpc"
    
    depends_on    = [
        google_compute_network.app_network
    ]
}

## Firewall Rule for SSH
resource "google_compute_firewall" "ssh_access" {
    name    = "ssh-firewall"
    network = google_compute_network.app_network.name

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]

    depends_on = [
        google_compute_network.app_network
    ]
}
