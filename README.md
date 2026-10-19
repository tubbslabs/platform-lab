# platform-lab

A platform engineering environment built from code: infrastructure provisioned
with Terraform on Hetzner Cloud, configured with Ansible, running Kubernetes (k3s),
with GitOps delivery and a full observability stack. To be extended to Azure.

## Architecture

- **Bastion host** (`jumpbox`): the single administrative entry point. Runs the
  toolchain and reaches cluster nodes over the private network.
- **Private network** `10.0.0.0/16`, subnet `10.0.1.0/24`.
- **k3s cluster**: one control plane node (`10.0.1.10`) and two agents
  (`10.0.1.20`, `10.0.1.21`), in a spread placement group so each node runs on
  separate physical hardware.
- **Cloud firewall**: only HTTP, HTTPS and ICMP are reachable publicly. SSH and
  the Kubernetes API are reachable only over the private network.

## Repository layout

| Path | Contents |
|---|---|
| `terraform/environments/hetzner-dev/` | Hetzner infrastructure |
| `ansible/` | Host configuration and k3s installation |
| `kubernetes/` | Cluster manifests (platform services and applications) |
| `docs/adr/` | Architecture decision records |

## Usage

Requires Terraform 1.9 or later and a Hetzner Cloud API token in `HCLOUD_TOKEN`.

    cd terraform/environments/hetzner-dev
    terraform init
    terraform plan -out=tfplan
    terraform apply tfplan

Applying also generates the Ansible inventory at `ansible/inventory/hosts.ini`.

## Status

- [x] Infrastructure provisioning (Terraform)
- [ ] Host configuration and k3s (Ansible)
- [ ] Packaging and GitOps delivery (Helm, Argo CD)
- [ ] Ingress and TLS (Traefik, cert-manager)
- [ ] CI (GitHub Actions)
- [ ] Observability (Prometheus, Alertmanager, Grafana, Loki, Thanos)
- [ ] Multi-cluster management (Rancher)
- [ ] Azure extension (AKS)
