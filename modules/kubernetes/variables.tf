// digital ocean variables
variable "do_token" {}
variable "do_image" {}
variable "do_region" {}
variable "do_size" {}
variable "do_name" {}
variable "do_tags" {
    type = "list"
}
variable "do_kubernetes_nodes" {}
variable "do_kubernetes_version" {}

// app settings
variable "container_image" {}
variable "container_port" {}
variable "dns_record" {}