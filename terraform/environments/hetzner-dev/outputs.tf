output "control_private_ip" {
  description = "Private IP of the k3s control plane node."
  value       = one(hcloud_server.control.network).ip
}

output "agent_private_ips" {
  description = "Private IPs of the k3s agent nodes."
  value       = [for s in hcloud_server.agent : one(s.network).ip]
}

output "control_public_ip" {
  description = "Public IPv4 of the control plane node."
  value       = hcloud_server.control.ipv4_address
}

output "agent_public_ips" {
  description = "Public IPv4 addresses of the agent nodes."
  value       = hcloud_server.agent[*].ipv4_address
}
