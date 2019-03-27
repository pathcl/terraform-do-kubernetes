# Configure the DigitalOcean Provider
provider "digitalocean" {}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.homero.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.homero.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.homero.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.homero.kube_config.0.cluster_ca_certificate)}"
}