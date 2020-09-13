## Virtual Private Gateway

resource "aws_vpn_gateway" "virtual_gw"{
    vpc_id = var.aws_vpc_id

    tags = {
        Name = "Virtual-GW"
    }
}

## Route Propogation
resource "aws_vpn_gateway_route_propagation" "public_private" {
    count = length(var.aws_route_table_ids)
    route_table_id = element(var.aws_route_table_ids,count.index)
    vpn_gateway_id = aws_vpn_gateway.virtual_gw.id

    depends_on = [
        aws_vpn_gateway.virtual_gw,
    ]
}


## Customer Gateway with PUblic IP of GCP Cloud Gateway

resource "aws_customer_gateway" "google" {
    bgp_asn = 65000
    ip_address = google_compute_address.vpn_ip.address
    type = "ipsec.1"

    tags = {
        Name = "Google Cloud Customer Gateway"
    }
    depends_on = [
        google_compute_address.vpn_ip,
    ]
}


## AWS VPN Tunnel

resource "aws_vpn_connection" "aws_to_gcp" {
    vpn_gateway_id = aws_vpn_gateway.virtual_gw.id
    customer_gateway_id = aws_customer_gateway.google.id
    type = "ipsec.1"
    static_routes_only = false

    tags = {
        Name = " AWS-To-Google VPN"
    }
    depends_on = [
        aws_vpn_gateway.virtual_gw,
        aws_customer_gateway.google,
    ]
}

