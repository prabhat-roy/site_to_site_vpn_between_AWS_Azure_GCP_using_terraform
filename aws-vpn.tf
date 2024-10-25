resource "aws_customer_gateway" "gcp-cgw1" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = google_compute_ha_vpn_gateway.gcp-gateway.vpn_interfaces[0].ip_address
  type       = "ipsec.1"
  tags = {
    Name = "GCP Public IP 1"
  }
}

resource "aws_customer_gateway" "gcp-cgw2" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = google_compute_ha_vpn_gateway.gcp-gateway.vpn_interfaces[1].ip_address
  type       = "ipsec.1"
  tags = {
    Name = "GCP Public IP 2"
  }
}

resource "aws_vpn_connection" "gcp-vpn1" {
  vpn_gateway_id                       = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id                  = aws_customer_gateway.gcp-cgw1.id
  type                                 = "ipsec.1"
  static_routes_only                   = false
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase1_dh_group_numbers      = ["14"]
  tunnel1_phase2_dh_group_numbers      = ["14"]
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase1_dh_group_numbers      = ["14"]
  tunnel2_phase2_dh_group_numbers      = ["14"]
  tunnel2_ike_versions                 = ["ikev2"]
  tags = {
    Name = "GCP VPN 1"
  }
}

resource "aws_vpn_connection" "gcp-vpn2" {
  vpn_gateway_id                       = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id                  = aws_customer_gateway.gcp-cgw2.id
  type                                 = "ipsec.1"
  static_routes_only                   = false
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase1_dh_group_numbers      = ["14"]
  tunnel1_phase2_dh_group_numbers      = ["14"]
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase1_dh_group_numbers      = ["14"]
  tunnel2_phase2_dh_group_numbers      = ["14"]
  tunnel2_ike_versions                 = ["ikev2"]
  tags = {
    Name = "GCP VPN 2"
  }
}

resource "aws_customer_gateway" "azure-cgw1" {
  bgp_asn    = var.azure_bgp_asn
  ip_address = azurerm_public_ip.azure_vpn_gateway_public_ip_1.ip_address
  type       = "ipsec.1"
  tags = {
    Name = "Azure Public IP 1"
  }
}

resource "aws_customer_gateway" "azure-cgw2" {
  bgp_asn    = var.azure_bgp_asn
  ip_address = azurerm_public_ip.azure_vpn_gateway_public_ip_1.ip_address
  type       = "ipsec.1"
  tags = {
    Name = "Azure Public IP 2"
  }
}

resource "aws_vpn_connection" "azure-vpn1" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.azure-cgw1.id
  type                = "ipsec.1"
  static_routes_only  = false
  tunnel1_inside_cidr = "169.254.21.0/30"
  tunnel2_inside_cidr = "169.254.21.4/30"
  tags = {
    Name = "Azure VPN 1"
  }
}

resource "aws_vpn_connection" "azure-vpn2" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.azure-cgw2.id
  type                = "ipsec.1"
  static_routes_only  = false
  tunnel1_inside_cidr = "169.254.22.0/30"
  tunnel2_inside_cidr = "169.254.22.4/30"
  tags = {
    Name = "Azure VPN 2"
  }
}