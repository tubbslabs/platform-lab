resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../../../ansible/inventory/hosts.ini"
  file_permission = "0644"

  content = <<-EOT
    [control]
    ${hcloud_server.control.name} ansible_host=${one(hcloud_server.control.network).ip}

    [agents]
    %{for s in hcloud_server.agent~}
    ${s.name} ansible_host=${one(s.network).ip}
    %{endfor~}

    [k3s:children]
    control
    agents

    [k3s:vars]
    ansible_user=root
    ansible_ssh_private_key_file=~/.ssh/nodes
  EOT
}
