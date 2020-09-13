## External IP address for Virtual Gateway

resource "google_compute_address" "vpn_ip" {
    name = "aws-vpn-ip"
}

## VPN Gateway
resource "google_compute_vpn_gateway" "gcp_aws_gateway" {
    name = "vpn-gateway"
    network = var.gcp_network_id
}

## ESP Forwarding rule
resource "google_compute_forwarding_rule" "esp_forward" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gcp_aws_gateway.self_link

  depends_on = [
      google_compute_address.vpn_ip,
      google_compute_vpn_gateway.gcp_aws_gateway

  ]
}

## UP 500 Routing Rule
resource "google_compute_forwarding_rule" "udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
   ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gcp_aws_gateway.self_link

  depends_on = [
      google_compute_address.vpn_ip,
      google_compute_vpn_gateway.gcp_aws_gateway

  ]
}

resource "google_compute_forwarding_rule" "udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
   ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gcp_aws_gateway.self_link

  depends_on = [
      google_compute_address.vpn_ip,
      google_compute_vpn_gateway.gcp_aws_gateway

  ]
}



## Google Compute Router

resource "google_compute_router" "gcp_vpn_router" {
    name = "gcp-vpn-router"
    network = var.gcp_network_id
    
    bgp{
        asn = aws_customer_gateway.google.bgp_asn
    } 

    depends_on = [
        aws_customer_gateway.google,
    ]
}

## VPN tunnel
resource "google_compute_vpn_tunnel"  "gcp_aws_vpn" {
    name = "gcp-aws-vpn-tunnel-1"
    peer_ip = aws_vpn_connection.aws_to_gcp.tunnel1_address
    shared_secret = aws_vpn_connection.aws_to_gcp.tunnel1_preshared_key
    ike_version = 1

    target_vpn_gateway = google_compute_vpn_gateway.gcp_aws_gateway.id

    router = google_compute_router.gcp_vpn_router.id
    depends_on = [
        aws_vpn_connection.aws_to_gcp,
        google_compute_vpn_gateway.gcp_aws_gateway,
        google_compute_router.gcp_vpn_router
    ]

}

## Computer Router Interface

resource "google_compute_router_interface" "gcp_vpn_router_interface" {
    name = "gcp-aws-vpn-router-interface"
    router = google_compute_router.gcp_vpn_router.name
    ip_range = "${aws_vpn_connection.aws_to_gcp.tunnel1_cgw_inside_address}/30"
    vpn_tunnel = google_compute_vpn_tunnel.gcp_aws_vpn.name
    depends_on = [
        google_compute_vpn_tunnel.gcp_aws_vpn,
        aws_vpn_connection.aws_to_gcp,
    ]
}

## Router Peer
resource "google_compute_router_peer" "gcp_vpn_router_peer" {
    name = "gcp-aws-vpn-bgp1"
    router = google_compute_router.gcp_vpn_router.name
    peer_ip_address = aws_vpn_connection.aws_to_gcp.tunnel1_vgw_inside_address
    peer_asn = aws_vpn_connection.aws_to_gcp.tunnel1_bgp_asn  
    interface  = google_compute_router_interface.gcp_vpn_router_interface.name

    depends_on = [
        google_compute_router_interface.gcp_vpn_router_interface,
        google_compute_router.gcp_vpn_router,
    ]
}