terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
  #token = "dop_v1_4dcf2b06bd0f6c26d866939edd3ec19b9a30fcf5a0035fdd45e6bb5f0a8b3914"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.id]
}

# Add key ssh in provider
data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

#documentation for kubernetes
resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = "k8s"
  region  = var.region
  version = "1.24.4-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 2
  }
}

variable "region" {
  default = ""
}

variable "do_token" {
  default = ""
}

variable "ssh_key_name" {
  default = ""
}

output "jenkins_ip" {
    value = digitalocean_droplet.jenkins.ipv4_address
}

resource "local_file" "name" {
    content = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
    filename = "kube_config.yaml"
}