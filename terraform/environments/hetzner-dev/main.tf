# Existing infrastructure, created by hand and read here rather than managed.
data "hcloud_network" "private" {
  name = "platform-lab"
}

resource "hcloud_ssh_key" "nodes" {
  name       = "platform-lab-nodes"
  public_key = file(pathexpand(var.node_ssh_public_key_path))
}

resource "hcloud_firewall" "nodes" {
  name = "platform-lab-nodes"

  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_placement_group" "nodes" {
  name = "platform-lab-nodes"
  type = "spread"
}

resource "hcloud_server" "control" {
  name               = "k3s-control-01"
  image              = "ubuntu-24.04"
  server_type        = var.server_type
  location           = var.location
  ssh_keys           = [hcloud_ssh_key.nodes.id]
  firewall_ids       = [hcloud_firewall.nodes.id]
  placement_group_id = hcloud_placement_group.nodes.id

  network {
    network_id = data.hcloud_network.private.id
    ip         = "10.0.1.10"
  }

  labels = {
    project = "platform-lab"
    role    = "control-plane"
  }
}

resource "hcloud_server" "agent" {
  count = var.agent_count

  name               = format("k3s-agent-%02d", count.index + 1)
  image              = "ubuntu-24.04"
  server_type        = var.server_type
  location           = var.location
  ssh_keys           = [hcloud_ssh_key.nodes.id]
  firewall_ids       = [hcloud_firewall.nodes.id]
  placement_group_id = hcloud_placement_group.nodes.id

  network {
    network_id = data.hcloud_network.private.id
    ip         = "10.0.1.${20 + count.index}"
  }

  labels = {
    project = "platform-lab"
    role    = "agent"
  }
}
