resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.compute,
  ]
}

resource "google_compute_subnetwork" "main" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.main.id
  region        = var.region
}

# Allocate an internal range for Private Service Connect to Cloud SQL (Service Networking)
resource "google_compute_global_address" "psc_range" {
  name          = var.psc_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psc_range.name]

  depends_on = [
    google_project_service.servicenetworking,
  ]
}

