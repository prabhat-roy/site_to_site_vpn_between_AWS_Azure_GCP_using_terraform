
resource "google_compute_ha_vpn_gateway" "gcp-gateway" {
  name       = "aws-vpn"
  region     = var.gcp_region
  network    = google_compute_network.gcp-vpc.name
  stack_type = "IPV4_IPV6"
}

resource "google_compute_external_vpn_gateway" "aws-gateway" {
  name            = "aws-gateway"
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  description     = "VPN gateway on AWS side"
  interface {
    id         = 0
    ip_address = aws_vpn_connection.vpn1.tunnel1_address
  }
  interface {
    id         = 1
    ip_address = aws_vpn_connection.vpn1.tunnel2_address
  }
  interface {
    id         = 2
    ip_address = aws_vpn_connection.vpn2.tunnel1_address
  }
  interface {
    id         = 3
    ip_address = aws_vpn_connection.vpn2.tunnel2_address
  }
}

resource "google_compute_vpn_tunnel" "vpn1" {
  name                            = "vpn-tunnel-1"
  peer_external_gateway           = google_compute_external_vpn_gateway.aws-gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = aws_vpn_connection.vpn1.tunnel1_preshared_key
  ike_version                     = 2
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-gateway.self_link
  router                          = google_compute_router.gcp-router.name
  vpn_gateway_interface           = 0
}

resource "google_compute_router_peer" "peer1" {
  name            = "peer-1"
  router          = google_compute_router.gcp-router.name
  region          = google_compute_router.gcp-router.region
  peer_ip_address = aws_vpn_connection.vpn1.tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_gateway.vpn_gateway.amazon_side_asn
  interface       = google_compute_router_interface.int1.name
}

resource "google_compute_router_interface" "int1" {
  name       = "interface-1"
  router     = google_compute_router.gcp-router.name
  region     = google_compute_router.gcp-router.region
  ip_range   = "${aws_vpn_connection.vpn1.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn1.name
}

resource "google_compute_vpn_tunnel" "vpn2" {
  name                            = "vpn-tunnel-2"
  peer_external_gateway           = google_compute_external_vpn_gateway.aws-gateway.id
  peer_external_gateway_interface = 1
  shared_secret                   = aws_vpn_connection.vpn1.tunnel2_preshared_key
  ike_version                     = 2
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-gateway.self_link
  router                          = google_compute_router.gcp-router.name
  vpn_gateway_interface           = 0
}

resource "google_compute_router_peer" "peer2" {
  name            = "peer-2"
  router          = google_compute_router.gcp-router.name
  region          = google_compute_router.gcp-router.region
  peer_ip_address = aws_vpn_connection.vpn1.tunnel2_vgw_inside_address
  peer_asn        = aws_vpn_gateway.vpn_gateway.amazon_side_asn
  interface       = google_compute_router_interface.int2.name
}

resource "google_compute_router_interface" "int2" {
  name       = "interface-2"
  router     = google_compute_router.gcp-router.name
  region     = google_compute_router.gcp-router.region
  ip_range   = "${aws_vpn_connection.vpn1.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn2.name
}

resource "google_compute_vpn_tunnel" "vpn3" {
  name                            = "vpn-tunnel-3"
  peer_external_gateway           = google_compute_external_vpn_gateway.aws-gateway.id
  peer_external_gateway_interface = 2
  shared_secret                   = aws_vpn_connection.vpn2.tunnel1_preshared_key
  ike_version                     = 2
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-gateway.self_link
  router                          = google_compute_router.gcp-router.name
  vpn_gateway_interface           = 1
}

resource "google_compute_router_peer" "peer3" {
  name            = "peer-3"
  router          = google_compute_router.gcp-router.name
  region          = google_compute_router.gcp-router.region
  peer_ip_address = aws_vpn_connection.vpn2.tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_gateway.vpn_gateway.amazon_side_asn
  interface       = google_compute_router_interface.int3.name
}

resource "google_compute_router_interface" "int3" {
  name       = "interface-3"
  router     = google_compute_router.gcp-router.name
  region     = google_compute_router.gcp-router.region
  ip_range   = "${aws_vpn_connection.vpn2.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn3.name
}

resource "google_compute_vpn_tunnel" "vpn4" {
  name                            = "vpn-tunnel-4"
  peer_external_gateway           = google_compute_external_vpn_gateway.aws-gateway.id
  peer_external_gateway_interface = 3
  shared_secret                   = aws_vpn_connection.vpn2.tunnel2_preshared_key
  ike_version                     = 2
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-gateway.self_link
  router                          = google_compute_router.gcp-router.name
  vpn_gateway_interface           = 1
}

resource "google_compute_router_peer" "peer4" {
  name            = "peer-4"
  router          = google_compute_router.gcp-router.name
  region          = google_compute_router.gcp-router.region
  peer_ip_address = aws_vpn_connection.vpn2.tunnel2_vgw_inside_address
  peer_asn        = aws_vpn_gateway.vpn_gateway.amazon_side_asn
  interface       = google_compute_router_interface.int4.name
}

resource "google_compute_router_interface" "int4" {
  name       = "interface-4"
  router     = google_compute_router.gcp-router.name
  region     = google_compute_router.gcp-router.region
  ip_range   = "${aws_vpn_connection.vpn2.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn4.name
}