resource "kubernetes_config_map" "iptables_nat_startup_script" {
	metadata {
		name = var.config_map_name
		namespace = "kube-system"
	}
	data = {
		iptables-script = <<EOF
		#! /bin/bash
                while true; do
                  iptables-save | grep MASQUERADE | grep -q "NAT-VPN"
                  if [ $? -ne 0 ]; then
                    echo "Missing NAT rule for VPN, adding it"
                    iptables -A POSTROUTING -d ${var.aws_vpc_cidr} -m comment --comment "NAT-VPN: SNAT for outbound traffic through VPN" -m addrtype ! --dst-type LOCAL -j MASQUERADE -t nat
                  fi
                  sleep 60
                done
		EOF
	}

}
