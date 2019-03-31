// digital ocean variables
variable "do_image" {}
variable "do_region" {}
variable "do_size" {}
variable "do_name" {}
variable "do_tags" {
    type = "list"
}
// prometheus settings
variable "prometheus_release" {}
variable "dns_domain" {}
variable "dns_record" {}