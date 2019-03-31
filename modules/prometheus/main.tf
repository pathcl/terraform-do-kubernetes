

resource "digitalocean_ssh_key" "default" {
  name       = "our ssh key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "prometheus" {
  name    = "${var.do_name}"
  image   = "${var.do_image}"
  region  = "${var.do_region}"
  tags    = "${var.do_tags}"
  size    = "${var.do_size}"
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}

resource "digitalocean_domain" "prometheus" {
  name       = "${var.dns_record}"
  ip_address = "${digitalocean_droplet.prometheus.ipv4_address}"
}

// manages the prometheus installation through an ansible playbook

resource "null_resource" "prometheus-server" {
  provisioner "remote-exec" {
  inline = ["apt-get update && apt install python-minimal -y"]

    connection {
      host        = "${digitalocean_droplet.prometheus.ipv4_address}"
      type        = "ssh"
      user        = "root"
		  private_key = "${file("~/.ssh/id_rsa")}"
    }
}
	// I dont want to check host key for now
	// This part will install prometheus through an ansible playbook
  // improve control over scraping targets!

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root ${path.module}/playbooks/deploy-prometheus.yaml -i ${path.module}/hosts.ini --extra-vars target=k8s.sanmartin.dev:9100"
  }
}

// hosts inventory for ansible should be represented on consul maybe
// since is only one ip addr this will work :)

resource "null_resource" "prom-hosts" {
  provisioner "local-exec" {
    command = "echo '${digitalocean_droplet.prometheus.ipv4_address}' > ${path.module}/hosts.ini"
  }
}