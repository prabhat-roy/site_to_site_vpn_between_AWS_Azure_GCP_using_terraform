resource "google_compute_network" "gcp-vpc" {
  name                    = "gcp-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "gcp_subnet" {
  name                     = "gcp-subnet"
  ip_cidr_range            = var.gcp_vpc_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.gcp-vpc.name
  private_ip_google_access = true
}

resource "google_compute_router" "gcp-router" {
  name    = "gcp-router"
  region  = var.gcp_region
  network = google_compute_network.gcp-vpc.id

  bgp {
    asn               = var.gcp_bgp_asn
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
  }
}

resource "google_compute_router_nat" "gcp-nat" {
  name                               = "gcp-nat-router"
  router                             = google_compute_router.gcp-router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}