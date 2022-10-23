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
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "jenkins" {
  image    = "ubuntu-22-04-x64"
  name     = "jenkins"
  region   = var.region
  size     = "s-2vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.devopselite.id]

  #script para criação automática java, jenkins, docker, kubectl
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    agent      = "true"
  }
  provisioner "file" {
    source      = "installjenkins.sh"
    destination = "/tmp/installjenkins.sh"
  }
  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installjenkins.sh",
      "sudo /tmp/installjenkins.sh",
    ]
  }
}

# Add key ssh in provider
data "digitalocean_ssh_key" "devopselite" {
  name = var.ssh_key_devopselite
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

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
  filename = "kube_config.yaml"
}

variable "region" {
  default = ""
}

variable "do_token" {
  default = ""
}

variable "ssh_key_devopselite" {
  default = ""
}

output "jenkins_ip" {
  value = digitalocean_droplet.jenkins.ipv4_address
}