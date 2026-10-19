# ADR 0001: Network design and administrative access

## Status
Accepted

## Context
The cluster nodes need outbound internet access (container images, OS packages)
and must serve HTTP/HTTPS once ingress is installed. Administrative access (SSH,
Kubernetes API) should not be exposed to the internet.

## Decision
- All nodes and the bastion host are attached to a private network,
  `10.0.1.0/24`.
- Administrative access goes through the bastion host, which reaches the nodes
  over the private network.
- The cloud firewall on the nodes permits only HTTP (80), HTTPS (443) and ICMP
  inbound on the public interface. Hetzner Cloud firewalls filter only the public
  interface, so private network traffic, including SSH and the Kubernetes API
  from the bastion, is unaffected.
- Nodes keep public IPv4 addresses, used for outbound traffic and inbound HTTP/HTTPS.

## Alternatives considered
- **Private-only nodes with a NAT gateway and load balancer.** Removes public
  addresses from the nodes entirely, so they are unroutable from the internet.
  Not adopted for this iteration: more components to provision and debug,
  without changing what is reachable given the firewall rules.
- **IPv6-only nodes.** Cheaper, but some registries and endpoints still behave
  poorly without IPv4.

## Consequences
- Security depends on the firewall being correct, rather than on the nodes being
  unroutable.
- Each node incurs the public IPv4 charge.
- A NAT gateway design remains a candidate for a future ADR.
