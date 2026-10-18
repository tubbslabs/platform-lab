variable "location" {
  type        = string
  default     = "nbg1" // Nuremberg, Germany
  description = "Hetzner location for all cluster resources."
}

variable "server_type" {
  type        = string
  default     = "cx23"
  description = "Server type for cluster nodes. cx23 is 2 vCPU, 4 GB RAM."
}

variable "agent_count" {
  type        = number
  default     = 2
  description = "Number of k3s agent (worker) nodes."

  validation {
    condition     = var.agent_count >= 1 && var.agent_count <= 5
    error_message = "agent_count must be between 1 and 5."
  }
}

variable "node_ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/nodes.pub"
  description = "Path to the public key installed on cluster nodes."
}
