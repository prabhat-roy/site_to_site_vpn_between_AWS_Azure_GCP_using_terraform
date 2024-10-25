resource "google_compute_firewall" "allow-icmp" {
  name          = "allow-icmp"
  network       = google_compute_network.gcp-vpc.id
  source_ranges = [var.aws_vpc_cidr, var.azure_vpc_cidr]
  allow {
    protocol = "icmp"

  }
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.gcp-vpc.id
  #source_ranges = ["35.235.240.0/20","${format(jsondecode(data.http.ipinfo.body).ip)}/32"]
  source_ranges = ["35.235.240.0/20", "${chomp(data.http.icanhazip.response_body)}/32"]
  allow {
    protocol = "tcp"
    ports    = [22]
  }
}