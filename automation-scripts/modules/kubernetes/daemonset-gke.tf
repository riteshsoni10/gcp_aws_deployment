resource "kubernetes_daemonset" "gke_vpn_nat_aws_cidr" {
	metadata {
		name = "aws-network-nat"
		namespace = "kube-system"
		labels = {
			app = "network-nat"
		}
	}

	spec {
		template {
			metadata {
				labels = {
					app = "network-nat"
				}
			}
			spec {
				container {
					name = "aws-network-nat"
					image = "gcr.io/google-containers/startup-script:v1"
					image_pull_policy = "Always"
					security_context {
						privileged = "true"
					}
					env {
						name = "Startup Script"
						value_from {
							config_map_key_ref {
								name = var.config_map_name 
								key = "iptables-script" 
							}
						}
					}
				}
			}
		}
	}
	
	depends_on = [
		 kubernetes_config_map.iptables_nat_startup_script
	]
}
