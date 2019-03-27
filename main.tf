// The idea of this module is to consume an image defined by:
//
// container_image = "pathcl/goworld:0.0.1"
// container_port = "8080"

// What is a container? 
// https://medium.com/devopslinks/the-missing-introduction-to-containerization-de1fbb73efc5
// 
// By...

// What do I need?
//
// a) provision a k8s cluster
// b) create a deployment/service-loadBalancer in k8s
// c) create domain using the previous loadBalancer
// d) profit

module "kubernetes" {
    // Define cluster
    source = "./modules/kubernetes"

    // Digital ocean settings
    do_image = "ubuntu-18-04-x64"
    do_kubernetes_nodes = "2"
    do_kubernetes_version = "1.13.5-do.0"
    do_name = "homero"
    do_region = "ams3"
    do_size = "s-1vcpu-2gb"
    do_tags = ["homero", "dev"]
    
    // Container to be deployed. Please note is using hub.docker.com as source
    container_image = "pathcl/goworld:0.0.1"
    container_port = "8080"

    // Domain record exposed
    dns_record = "homero.dev"
}
